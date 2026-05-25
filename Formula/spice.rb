class Spice < Formula
  desc "Local Shai-Hulud exposure checker for developers"
  homepage "https://github.com/turenlabs/spice"
  version "0.1.15"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_darwin_arm64.tar.gz"
      sha256 "5d99ad3a39b19a67575996c0319069174662dfe32987cf12904fe72c345f1a74"
    else
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_darwin_amd64.tar.gz"
      sha256 "6fab38465169201406f8b6db82872df809be3d7758fd7c35ea00125e1a06e4cc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_linux_arm64.tar.gz"
      sha256 "48d0eeb3da6b9b667e0785ed3b007f86c4313b71babd41274d1157cfa0774ff4"
    else
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_linux_amd64.tar.gz"
      sha256 "4e1b9f94199f10214b600b302a65f5e970e107ba6c8413beeab02dec38b59a04"
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
