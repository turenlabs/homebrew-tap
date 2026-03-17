class Batou < Formula
  desc "Generation Time SAST For Claude Code"
  homepage "https://github.com/turenlabs/batou"
  version "0.4.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/batou/releases/download/v#{version}/batou-darwin-arm64"
      sha256 "8044a2ee68f97acc72581dcfb1eb7f02b9769494d7d456b0a79f830055d4923a"
    else
      url "https://github.com/turenlabs/batou/releases/download/v#{version}/batou-darwin-amd64"
      sha256 "4a3dcf27492941df159dd912dcdaa1ea1b3688060f53b8fe7dfa9dfe31c0c7a2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/batou/releases/download/v#{version}/batou-linux-arm64"
      sha256 "71b9c532ad2511d4892ab6b6adead1700dc31ebc697be0666a30634636017e01"
    else
      url "https://github.com/turenlabs/batou/releases/download/v#{version}/batou-linux-amd64"
      sha256 "1834dda7a6c01b6bda7670293e22bbfc1d9928763ceaed83fd260077649e9e71"
    end
  end

  def install
    cpu = Hardware::CPU.arm? ? "arm64" : "amd64"
    if OS.mac?
      bin.install "batou-darwin-#{cpu}" => "batou"
    else
      bin.install "batou-linux-#{cpu}" => "batou"
    end
  end

  test do
    assert_predicate bin/"batou", :executable?
  end
end
