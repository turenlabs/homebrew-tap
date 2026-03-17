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

    # Install a setup script that configures Claude Code hooks
    (bin/"batou-setup").write <<~BASH
      #!/usr/bin/env bash
      set -euo pipefail

      HOOK_DIR="$HOME/.batou/hooks"
      HOOK_SCRIPT="$HOOK_DIR/batou-hook.sh"
      SETTINGS_FILE="$HOME/.claude/settings.json"

      echo "Setting up Batou Claude Code hooks..."

      # Create hook wrapper script
      mkdir -p "$HOOK_DIR"
      cat > "$HOOK_SCRIPT" << 'HOOKEOF'
      #!/usr/bin/env bash
      set -euo pipefail
      BATOU_BIN=""
      if command -v batou &>/dev/null; then
          BATOU_BIN="$(command -v batou)"
      elif [[ -x "$HOME/.batou/bin/batou" ]]; then
          BATOU_BIN="$HOME/.batou/bin/batou"
      fi
      if [[ -z "$BATOU_BIN" ]]; then
          exit 0
      fi
      exec "$BATOU_BIN"
      HOOKEOF
      chmod 755 "$HOOK_SCRIPT"
      echo "Hook script installed: $HOOK_SCRIPT"

      # Configure Claude Code settings
      mkdir -p "$HOME/.claude"

      if [[ -f "$SETTINGS_FILE" ]] && grep -q "batou" "$SETTINGS_FILE" 2>/dev/null; then
          echo "Batou hooks already configured in $SETTINGS_FILE"
          echo "Updating hook script only."
          echo "Done!"
          exit 0
      fi

      BATOU_HOOKS=$(cat << 'JSONEOF'
      {
        "hooks": {
          "PreToolUse": [
            {
              "matcher": "Write|Edit|NotebookEdit",
              "hooks": [
                {
                  "type": "command",
                  "command": "HOOK_PLACEHOLDER",
                  "timeout": 30,
                  "statusMessage": "Batou: Scanning for vulnerabilities..."
                }
              ]
            }
          ],
          "PostToolUse": [
            {
              "matcher": "Write|Edit|NotebookEdit",
              "hooks": [
                {
                  "type": "command",
                  "command": "HOOK_PLACEHOLDER",
                  "timeout": 30,
                  "statusMessage": "Batou: Deep security scan..."
                }
              ]
            }
          ]
        }
      }
      JSONEOF
      )

      BATOU_HOOKS=$(echo "$BATOU_HOOKS" | sed "s|HOOK_PLACEHOLDER|$HOOK_SCRIPT|g")

      if [[ -f "$SETTINGS_FILE" ]]; then
          if command -v jq &>/dev/null; then
              TMP_FILE=$(mktemp)
              echo "$BATOU_HOOKS" | jq -s '.[0] * .[1]' "$SETTINGS_FILE" - > "$TMP_FILE"
              mv "$TMP_FILE" "$SETTINGS_FILE"
              echo "Merged Batou hooks into existing $SETTINGS_FILE"
          else
              echo "Warning: jq not found. Please manually add Batou hooks to $SETTINGS_FILE"
              echo "$BATOU_HOOKS"
              exit 1
          fi
      else
          echo "$BATOU_HOOKS" > "$SETTINGS_FILE"
          echo "Created $SETTINGS_FILE with Batou hooks"
      fi

      echo "Done! Batou will scan code written by Claude Code for vulnerabilities."
    BASH
  end

  def caveats
    <<~EOS
      To configure Claude Code hooks, run:
        batou-setup

      This will:
        - Install a hook script at ~/.batou/hooks/batou-hook.sh
        - Configure Claude Code hooks in ~/.claude/settings.json

      After setup, Batou will automatically scan code written by
      Claude Code for security vulnerabilities.
    EOS
  end

  test do
    assert_predicate bin/"batou", :executable?
  end
end
