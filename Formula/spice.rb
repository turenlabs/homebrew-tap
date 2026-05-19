class Spice < Formula
  desc "Local Shai-Hulud exposure checker for developers"
  homepage "https://github.com/turenlabs/spice"
  version "0.1.6"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_darwin_arm64.tar.gz"
      sha256 "d31adb34d3404d15d6f0145408c151ae4574fa686793f1462aa3e0ccf2e1cc5a"
    else
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_darwin_amd64.tar.gz"
      sha256 "66d09fe362aec14ead92e6dd51dd6041dacb8b2aaa6facc7bdf4f9c967879092"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_linux_arm64.tar.gz"
      sha256 "40ab8127cacf41602e580f8fc21363b7742c5d49f0260a517ad63c5bd41e3d4a"
    else
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_linux_amd64.tar.gz"
      sha256 "44be7101eb5e5354f41ebe366d1ff04bc088e561b9cd58213d6d64b6849b70b1"
    end
  end

  def install
    bin.install Dir["spice_#{version}_*/spice"].first => "spice"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spice version")
  end
end
