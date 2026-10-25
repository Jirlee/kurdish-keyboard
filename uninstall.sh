#!/usr/bin/env bash
# Remove the Kurdish United Keyboard layout and restore a single base layout.
set -euo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
RULES_FILE="$CONFIG_DIR/xkb/rules/evdev.xml"

rm -f "$CONFIG_DIR/xkb/symbols/ku_custom" \
      "$HOME/.local/bin/ku-keyboard" \
      "$CONFIG_DIR/autostart/ku-keyboard.desktop"

# Only remove the registry file if it is the one we installed.
if [[ -f "$RULES_FILE" ]] && grep -q "ku_custom" "$RULES_FILE" \
    && [[ "$(grep -c "<layout>" "$RULES_FILE")" -eq 1 ]]; then
    rm -f "$RULES_FILE"
fi

if [[ "${XDG_SESSION_TYPE:-x11}" == "wayland" ]]; then
    echo "Removed. Also remove \"KU (United Keyboard)\" from your keyboard settings."
    exit 0
fi

BASE_LAYOUT="${BASE_LAYOUT:-$(setxkbmap -query | awk '/^layout:/ { split($2, a, ","); print a[1] }')}"
setxkbmap -layout "$BASE_LAYOUT" -option ""
echo "Removed. Layout restored to: $BASE_LAYOUT"
