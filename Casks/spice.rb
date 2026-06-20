cask "spice" do
  version "0.1.18"
  sha256 "8a08a9bf0d1d0c141c87c2c20e2464083849e839e0b462af93333b74f59cf1c8"

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
