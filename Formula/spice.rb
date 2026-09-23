class Spice < Formula
  desc "Local Shai-Hulud exposure checker for developers"
  homepage "https://github.com/turenlabs/spice"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v0.1.28/spice_0.1.28_darwin_arm64.tar.gz"
      sha256 "bf51f7a19fd9ddddf6fbb40df93ffcc2eb7cc803b4e5674d043d8f4ec619208c"
    else
      url "https://github.com/turenlabs/spice/releases/download/v0.1.28/spice_0.1.28_darwin_amd64.tar.gz"
      sha256 "7b4c32198f252ea767e4a3a1aa9534e2dcbac27a817b8e8d871f23b8de9336fa"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v0.1.28/spice_0.1.28_linux_arm64.tar.gz"
      sha256 "944fc062fcee722c23c9e27b60b8a00d1662547414176979f4626332018044b8"
    else
      url "https://github.com/turenlabs/spice/releases/download/v0.1.28/spice_0.1.28_linux_amd64.tar.gz"
      sha256 "6f9fc74aec47c87d5a019b1c647ddecaa3e78453506aff46e07787375e6186b8"
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
