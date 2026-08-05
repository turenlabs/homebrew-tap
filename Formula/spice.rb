class Spice < Formula
  desc "Local Shai-Hulud exposure checker for developers"
  homepage "https://github.com/turenlabs/spice"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v0.1.26/spice_0.1.26_darwin_arm64.tar.gz"
      sha256 "25f295822f3580333a8b66543c6fb126103c20e63a233c05574705d56003683c"
    else
      url "https://github.com/turenlabs/spice/releases/download/v0.1.26/spice_0.1.26_darwin_amd64.tar.gz"
      sha256 "21f5067727cc98458d5027d3c218a6ad5fc84b6be9fa3827159a74944168a141"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v0.1.26/spice_0.1.26_linux_arm64.tar.gz"
      sha256 "baf9606e43e92f3eb2110a852b0bb77149079d010a4b87e485db02283a687192"
    else
      url "https://github.com/turenlabs/spice/releases/download/v0.1.26/spice_0.1.26_linux_amd64.tar.gz"
      sha256 "c91bc9c4bcade75fd23439b08451473e651f7e8f45390e8736d1b9798e638154"
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
