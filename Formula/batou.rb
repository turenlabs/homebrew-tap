class Batou < Formula
  desc "Generation Time SAST For Claude Code"
  homepage "https://github.com/turenlabs/batou"
  version "1.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/batou/releases/download/v#{version}/batou-darwin-arm64"
      sha256 "7595ac437684b05a848468823f14dcb1c1c4e0b654870929c2b2c7ecee818091"
    else
      url "https://github.com/turenlabs/batou/releases/download/v#{version}/batou-darwin-amd64"
      sha256 "e0c17e8a87c1e4a004f6d165da06086482435ab3e598d9f397ae360cade6026a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/turenlabs/batou/releases/download/v#{version}/batou-linux-arm64"
      sha256 "92a78657c80c0e0085f8e079df3c5cec523be320cab9ecc383b9f69f450745a8"
    else
      url "https://github.com/turenlabs/batou/releases/download/v#{version}/batou-linux-amd64"
      sha256 "1c5c21fad5015e455a8f8fb2638191c4af33e27fc14a80bd6d79a7dd4a00b83f"
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
