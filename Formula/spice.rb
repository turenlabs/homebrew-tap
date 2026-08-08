class Spice < Formula
  desc "Local Shai-Hulud exposure checker for developers"
  homepage "https://github.com/turenlabs/spice"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v0.1.27/spice_0.1.27_darwin_arm64.tar.gz"
      sha256 "2b8dab4d7b978f83ad57913a2efd153afed40f2f9fe23dfe4822963a52f2899d"
    else
      url "https://github.com/turenlabs/spice/releases/download/v0.1.27/spice_0.1.27_darwin_amd64.tar.gz"
      sha256 "5c6fb2032dd28bf978c41f3e3fe45860855f0958e5ee2244ab639e4ab412810a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v0.1.27/spice_0.1.27_linux_arm64.tar.gz"
      sha256 "9c85adf95ae59252b213e01918664171660a6bd243f897c9a3e28fb72ff3fca1"
    else
      url "https://github.com/turenlabs/spice/releases/download/v0.1.27/spice_0.1.27_linux_amd64.tar.gz"
      sha256 "385ce9c5493bbe8b855bd16ffe2ad7162dc5f1b7bbdea01cab343abb80ac0295"
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
