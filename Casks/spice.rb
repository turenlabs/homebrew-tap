cask "spice" do
  version "0.1.20"
  sha256 "fffadb0e772fe884ec939a299174f99ea8185c13b4b5c4de7c9b34e7acc3c19c"

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
