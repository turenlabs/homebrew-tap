# Homebrew formula for OMC.
#
# Install (public tap) — downloads the prebuilt binary, no compile:
#   brew install turenlabs/tap/omc
# Build the latest main from source instead:
#   brew install --HEAD turenlabs/tap/omc
#
# The default install pours the prebuilt `omc` from the GitHub Release for your
# platform (the omc repo's CI release workflow builds the binaries). After each
# release, run `./bump-omc.sh <version>` in this tap to regenerate the
# per-platform `url`/`sha256` and `version` below from the release's SHA256SUMS.
class Omc < Formula
  desc "Deny-by-default npm/PyPI replacement that compiles packages to verified bytecode"
  homepage "https://github.com/turenlabs/omc"
  license "Apache-2.0"
  version "0.1.2"

  on_macos do
    on_arm do
      url "https://github.com/turenlabs/omc/releases/download/v0.1.2/omc-0.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "8c1c0d69d904e79e60cddc752ab89629f7331e5243d14ef393f9de892fc69a62"
    end
    on_intel do
      url "https://github.com/turenlabs/omc/releases/download/v0.1.2/omc-0.1.2-x86_64-apple-darwin.tar.gz"
      sha256 "8430b8620ad9c0261214d169db6f6fb5fb3b13b090d4f481e40702c794b40f37"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/turenlabs/omc/releases/download/v0.1.2/omc-0.1.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bdcaad64ef047549a15449fde1941a4ffcd2650d9c01cc97c6186c0c84f86ddf"
    end
  end

  # `brew install --HEAD` builds the latest main from source instead of pouring
  # a release binary; only then is a Rust toolchain needed.
  head do
    url "https://github.com/turenlabs/omc.git", branch: "main"
    depends_on "rust" => :build
  end

  def install
    if build.head?
      system "cargo", "build", "--release", "--locked", "--package", "omc-cli"
      bin.install "target/release/omc"
      # Recommended global policy ships in the source tree (HEAD only).
      (share/"omc").install "examples/omc.global.toml"
    else
      # Prebuilt release tarball: `omc` sits at the extracted root next to shims/.
      bin.install "omc"
    end

    # The drop-in node/npm/npx/pip/pip3/python/python3/twine shims are symlinks
    # to the single OMC binary. Installing them onto PATH would shadow the system
    # tools, so they ship under libexec and are enabled opt-in (see caveats).
    (libexec/"shims").mkpath
    %w[npm npx node pip pip3 python python3 twine].each do |shim|
      (libexec/"shims"/shim).make_symlink bin/"omc"
    end
  end

  def caveats
    <<~EOS
      `omc` is installed and ready to use.

      OMC also ships drop-in `node`, `npm`, `npx`, `pip`, `pip3`, `python`,
      `python3`, and `twine` shims that route through OMC's deny-by-default
      runtime. They are NOT on your PATH by default because they would shadow the
      system tools. To enable them (opt-in), prepend the shim directory:

        export PATH="#{opt_libexec}/shims:$PATH"

      Reading sensitive files (.ssh, .env, private keys, .npmrc tokens, cloud
      credentials) is denied by default even under broad grants. Grant an exact
      `fs.read:<path>` to allow one file, or pass `--allow-sensitive` to override.

      A supply-chain freshness floor (`min-release-age`) of 14 days is on by
      default. A recommended global policy lives at examples/omc.global.toml in
      the repo; copy it to ~/.omc/omc.toml to tune org-wide defaults.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omc --version")

    # Smoke-test the public surface offline: `init` scaffolds the project files.
    # (exec-cell is a dev-only command not built into release binaries.)
    # batou:ignore BATOU-RUBYAST-002 -- array-form system() (no shell), all args are literals/Homebrew testpath, not user input
    system bin/"omc", "--project-dir", testpath, "init", "--name", "smoke"
    assert_predicate testpath/"omc.toml", :exist?
  end
end
