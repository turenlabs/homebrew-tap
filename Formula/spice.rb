class Spice < Formula
  desc "Local Shai-Hulud exposure checker for developers"
  homepage "https://github.com/turenlabs/spice"
  version "0.1.14"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_darwin_arm64.tar.gz"
      sha256 "47f3869a89406b0857e47ed9cc2ecc4e7086e7f2f832c11641f31c6352ce1d9f"
    else
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_darwin_amd64.tar.gz"
      sha256 "4df06877e3d644d4ec29b241498d9b217da9528bdb3ed76a1a5500bbc2450195"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_linux_arm64.tar.gz"
      sha256 "5b5e65b14c751e7a45f38162bb6b6918941180d9b41eea6df6c8302a6067f95a"
    else
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_linux_amd64.tar.gz"
      sha256 "e16d0fa7c292ce2bab27f343f071bd455ed252f0bdedfd00d2b165a8bb15c55b"
    end
  end

  def install
    binary = if File.exist?("spice")
      "spice"
    else
      Dir["spice_#{version}_*/spice"].first
    end

    bin.install binary => "spice"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spice version")
  end
end
