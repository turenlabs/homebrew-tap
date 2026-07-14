cask "spice" do
  version "0.1.22"
  sha256 "210e7f95c3934027f2164e2e6018d1a31dd8c447a25d2e6de05f14063cc06f2b"

  url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_macos_app.zip"
  name "Spice"
  desc "Local Shai-Hulud exposure checker for developers"
  homepage "https://github.com/turenlabs/spice"

  depends_on macos: :big_sur
  depends_on formula: "turenlabs/tap/spice"

  app "spice.app", target: "Spice.app"

  zap trash: [
    "~/Library/Application Support/Spice",
    "~/Library/Preferences/com.turenlabs.spice.plist",
    "~/Library/Saved Application State/com.turenlabs.spice.savedState",
  ]
end
