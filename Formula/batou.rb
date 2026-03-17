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

  def post_install
    hook_dir = Pathname.new(Dir.home)/".batou"/"hooks"
    hook_dir.mkpath

    hook_script = hook_dir/"batou-hook.sh"
    hook_script.write <<~BASH
      #!/usr/bin/env bash
      set -euo pipefail
      BATOU_BIN=""
      if [[ -x "#{HOMEBREW_PREFIX}/bin/batou" ]]; then
          BATOU_BIN="#{HOMEBREW_PREFIX}/bin/batou"
      elif [[ -x "$HOME/.batou/bin/batou" ]]; then
          BATOU_BIN="$HOME/.batou/bin/batou"
      elif command -v batou &>/dev/null; then
          BATOU_BIN="$(command -v batou)"
      fi
      if [[ -z "$BATOU_BIN" ]]; then
          exit 0
      fi
      exec "$BATOU_BIN"
    BASH
    hook_script.chmod 0755

    setup_claude_hooks(hook_script)
  end

  def setup_claude_hooks(hook_script)
    settings_dir = Pathname.new(Dir.home)/".claude"
    settings_dir.mkpath
    settings_file = settings_dir/"settings.json"

    if settings_file.exist?
      contents = settings_file.read
      return if contents.include?("batou")
    end

    batou_hooks = {
      "hooks" => {
        "PreToolUse" => [
          {
            "matcher" => "Write|Edit|NotebookEdit",
            "hooks" => [
              {
                "type" => "command",
                "command" => hook_script.to_s,
                "timeout" => 30,
                "statusMessage" => "Batou: Scanning for vulnerabilities...",
              },
            ],
          },
        ],
        "PostToolUse" => [
          {
            "matcher" => "Write|Edit|NotebookEdit",
            "hooks" => [
              {
                "type" => "command",
                "command" => hook_script.to_s,
                "timeout" => 30,
                "statusMessage" => "Batou: Deep security scan...",
              },
            ],
          },
        ],
      },
    }

    if settings_file.exist?
      require "json"
      existing = JSON.parse(settings_file.read)
      existing["hooks"] ||= {}
      batou_hooks["hooks"].each do |event, entries|
        existing["hooks"][event] ||= []
        existing["hooks"][event].concat(entries)
      end
      settings_file.write(JSON.pretty_generate(existing) + "\n")
    else
      require "json"
      settings_file.write(JSON.pretty_generate(batou_hooks) + "\n")
    end

    ohai "Batou Claude Code hooks configured in #{settings_file}"
  end

  def caveats
    <<~EOS
      Batou has been configured as a Claude Code hook.

      The hook script is at:
        ~/.batou/hooks/batou-hook.sh

      Claude Code settings updated at:
        ~/.claude/settings.json

      Batou will automatically scan code written by Claude Code
      for security vulnerabilities.
    EOS
  end

  test do
    assert_predicate bin/"batou", :executable?
  end
end
