cask "spice" do
  version "0.1.24"
  sha256 "0c958e8b23e0e1cf4f71c083ab2cf2eb1b2a456e7aa62f6e167704ccedfb4a29"

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
