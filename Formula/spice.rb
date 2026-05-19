class Spice < Formula
  desc "Local Shai-Hulud exposure checker for developers"
  homepage "https://github.com/turenlabs/spice"
  version "0.1.9"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_darwin_arm64.tar.gz"
      sha256 "8c7f6888863dd82278c23e04bd62a58dde55659078601941f8cd2dc6c75a11f6"
    else
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_darwin_amd64.tar.gz"
      sha256 "b4a7da6e245d24c41ec11a6cf27a04e18a3f7a405e6f2a01bf6b1e56593632ff"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_linux_arm64.tar.gz"
      sha256 "f56bea71150f3e15d9c4081df6f55637b6893edf6bb43b8d37d567ba3ddd22bd"
    else
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_linux_amd64.tar.gz"
      sha256 "8748139bcc69910c549b70f432ca902716166c6f2c6ae28cbe81329a217afcd2"
    end
  end

  def install
    bin.install Dir["spice_#{version}_*/spice"].first => "spice"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spice version")
  end
end
