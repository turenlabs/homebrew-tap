class Spice < Formula
  desc "Local Shai-Hulud exposure checker for developers"
  homepage "https://github.com/turenlabs/spice"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v0.1.25/spice_0.1.25_darwin_arm64.tar.gz"
      sha256 "4258414c085b1a81c2267e171319645a41c3cc2a7430b91c65ed5585ba8c5322"
    else
      url "https://github.com/turenlabs/spice/releases/download/v0.1.25/spice_0.1.25_darwin_amd64.tar.gz"
      sha256 "3d341996807a1e7a34bf3d441cd93f8848ac8dc5e01ab4fefce6438f6bf48bcb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v0.1.25/spice_0.1.25_linux_arm64.tar.gz"
      sha256 "c3d269f6687bc3d20e0415d110f6d9a13497608fe55848816dd3547ba3cb4027"
    else
      url "https://github.com/turenlabs/spice/releases/download/v0.1.25/spice_0.1.25_linux_amd64.tar.gz"
      sha256 "ba62688ecf4032518bdf9f07f22c3ce4a40c2997f74165d3b40aa0b4a2d9d61c"
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
