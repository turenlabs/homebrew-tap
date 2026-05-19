class Spice < Formula
  desc "Local Shai-Hulud exposure checker for developers"
  homepage "https://github.com/turenlabs/spice"
  version "0.1.8"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_darwin_arm64.tar.gz"
      sha256 "248740c458794a2555b4fcaa01a8ce2ba1f9faef0a15c63f5e6ef5f4a15a657d"
    else
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_darwin_amd64.tar.gz"
      sha256 "92a02918a06a3fa3d846eea63e3b942f63ecbf6c99373234fa45354a7c2840af"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_linux_arm64.tar.gz"
      sha256 "39d9f955598e8577d01bbee93d3f9606c203d89a45a61c5b52ca9d359527a6d5"
    else
      url "https://github.com/turenlabs/spice/releases/download/v#{version}/spice_#{version}_linux_amd64.tar.gz"
      sha256 "e1e428ca77e6cdcb26bef8aea961bddfeb5c184abb16a2db4be65c93abafd189"
    end
  end

  def install
    bin.install Dir["spice_#{version}_*/spice"].first => "spice"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spice version")
  end
end
