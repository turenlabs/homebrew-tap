#!/usr/bin/env bash
# Bump the omc formula in this tap to a new release.
#
#   ./bump-omc.sh 0.1.2
#
# Fetches the omc release's SHA256SUMS and rewrites each platform's prebuilt-
# tarball url + sha256 and the version in Formula/omc.rb. Then review and push:
#   git commit -am "omc 0.1.2" && git push
#
# No token needed: you run this locally with your own push access. omc's release
# workflow only builds the binaries; this tap owns the formula.
set -euo pipefail

VERSION="${1:?usage: ./bump-omc.sh <version>   e.g. ./bump-omc.sh 0.1.2}"
SRC_REPO="${SRC_REPO:-turenlabs/omc}"
TAG="v${VERSION}"

cd "$(dirname "$0")"

SUMS_URL="https://github.com/${SRC_REPO}/releases/download/${TAG}/SHA256SUMS"
echo "Fetching ${SUMS_URL}"
sums="$(mktemp)"
curl -fsSL "${SUMS_URL}" -o "$sums"
cat "$sums"

python3 - "$VERSION" "$SRC_REPO" "$sums" <<'PY'
import re, sys

version, src_repo, sums_path = sys.argv[1], sys.argv[2], sys.argv[3]
# Must match the formula's on_macos/on_linux blocks (a subset of omc's
# release.yml build matrix; the musl targets are released but not poured by
# Homebrew).
targets = [
    "aarch64-apple-darwin",
    "x86_64-apple-darwin",
    "aarch64-unknown-linux-gnu",
    "x86_64-unknown-linux-gnu",
]

sums = {}
for line in open(sums_path):
    parts = line.split()
    if len(parts) == 2:
        sums[parts[1].lstrip("*")] = parts[0]

text = open("Formula/omc.rb").read()
text = re.sub(r'version "[^"]*"', f'version "{version}"', text, count=1)

for target in targets:
    asset = f"omc-{version}-{target}.tar.gz"
    sha = sums.get(asset)
    if not sha:
        raise SystemExit(f"missing sha256 for {asset} in SHA256SUMS")
    url = f"https://github.com/{src_repo}/releases/download/v{version}/{asset}"
    text = re.sub(rf'url "[^"]*{re.escape(target)}\.tar\.gz"', f'url "{url}"', text, count=1)
    text = re.sub(
        rf'(url "{re.escape(url)}"\n\s*sha256 ")[0-9a-f]{{64}}(")',
        rf'\g<1>{sha}\g<2>',
        text,
        count=1,
    )

open("Formula/omc.rb", "w").write(text)
print(f"Formula/omc.rb bumped to {version} ({len(targets)} platforms)")
PY

echo
echo "Done. Review the diff, then: git commit -am \"omc ${VERSION}\" && git push"
