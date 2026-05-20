class Spice < Formula
  desc "Local Shai-Hulud exposure checker for developers"
  homepage "https://github.com/turenlabs/spice"
  version "0.1.11"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_darwin_arm64.tar.gz"
      sha256 "8d3db5ac00adc73bee0afe9e096374ca33bb0bf94bc9cb83fd11b360305dd4b4"
    else
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_darwin_amd64.tar.gz"
      sha256 "812be10e084f09a84a8fc62c6985106c6aee30534c7e27d1e787c6999ac96d0e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_linux_arm64.tar.gz"
      sha256 "34926f8b33debf68f6632fb71e7c426243b43a70017337e74083b38d578b4276"
    else
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_linux_amd64.tar.gz"
      sha256 "7a6cd5198599dbeec1afb217f64fe6f7db55a0d13a6ebbbc159e7518f306ed76"
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
