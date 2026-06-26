cask "spice" do
  version "0.1.19"
  sha256 "908629cb25f2049571226229feae239b2fd55c7948b298063248672794ad1dc6"

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
