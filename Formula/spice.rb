class Spice < Formula
  desc "Local Shai-Hulud exposure checker for developers"
  homepage "https://github.com/turenlabs/spice"
  version "0.1.16"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_darwin_arm64.tar.gz"
      sha256 "f0784560c25f1e5dc32370656a320b246f7c11ee0484efc426a2d06a70f5b16b"
    else
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_darwin_amd64.tar.gz"
      sha256 "64a957a15ec4fb19a2de09f69a4f6243416bbd212d11385bbe07617cde53c512"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_linux_arm64.tar.gz"
      sha256 "72d58d253b5a6cdaec91dccc8d0a98dfed159fd50e2a4a1e32ff72c29b116447"
    else
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_linux_amd64.tar.gz"
      sha256 "d10b6a5764d83de261ddc0b1b8697b04fbeffbcc5852b9ed4f460cb53ae72211"
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
