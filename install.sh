#!/usr/bin/env bash
# Install the Kurdish United Keyboard layout for the current user (X11 and Wayland, no root needed).
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
XKB_DIR="$CONFIG_DIR/xkb"
BIN_DIR="$HOME/.local/bin"
AUTOSTART_DIR="$CONFIG_DIR/autostart"
SESSION="${XDG_SESSION_TYPE:-x11}"

# Layout file and registry entry (read by libxkbcommon on Wayland and by GNOME/KDE settings).
install -Dm644 "$SRC_DIR/symbols/ku_custom" "$XKB_DIR/symbols/ku_custom"

# Remove files left by older versions that used the name "ckb_custom".
rm -f "$XKB_DIR/symbols/ckb_custom" "$BIN_DIR/ckb-keyboard" "$AUTOSTART_DIR/ckb-keyboard.desktop"

RULES_FILE="$XKB_DIR/rules/evdev.xml"
if [[ -f "$RULES_FILE" ]] && ! grep -qE "ku_custom|ckb_custom" "$RULES_FILE"; then
    echo "Warning: $RULES_FILE already exists and was not changed."
    echo "         Add the <layout> block from rules/evdev.xml to it manually."
else
    install -Dm644 "$SRC_DIR/rules/evdev.xml" "$RULES_FILE"
fi

if [[ "$SESSION" == "wayland" ]]; then
    echo "Done. Log out and back in, then add the layout in your keyboard settings:"
    echo "  GNOME: Settings > Keyboard > Input Sources > + > Kurdish > KU (United Keyboard)"
    echo "  KDE:   System Settings > Keyboard > Layouts > Add > KU (United Keyboard)"
    exit 0
fi

# X11: load the layout directly into the X server, now and at every login.

# First layout currently in use, e.g. "de" or "us".
BASE_LAYOUT="${BASE_LAYOUT:-$(setxkbmap -query | awk '/^layout:/ { split($2, a, ","); print a[1] }')}"
case "$BASE_LAYOUT" in
    de|at|ch) VARIANT="qwertz" ;;
    *)        VARIANT="basic" ;;
esac
TOGGLE="${TOGGLE:-grp:alt_shift_toggle}"

echo "Base layout: $BASE_LAYOUT | Kurdish variant: $VARIANT | Toggle: $TOGGLE"

install -d "$BIN_DIR"
cat > "$BIN_DIR/ku-keyboard" <<EOF
#!/usr/bin/env bash
# Load "$BASE_LAYOUT" + custom Kurdish layout into the running X server.
setxkbmap -layout "$BASE_LAYOUT,ku_custom" -variant ",$VARIANT" -option "" -option "$TOGGLE" -print \\
    | xkbcomp -I"$XKB_DIR" -w 0 - "\$DISPLAY"
EOF
chmod 755 "$BIN_DIR/ku-keyboard"

install -d "$AUTOSTART_DIR"
cat > "$AUTOSTART_DIR/ku-keyboard.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Kurdish United Keyboard
Comment=Load the Kurdish United Keyboard layout
Exec=sh -c "sleep 3 && $BIN_DIR/ku-keyboard"
X-GNOME-Autostart-enabled=true
EOF

"$BIN_DIR/ku-keyboard"
echo "Done. Press Alt+Shift to switch between $BASE_LAYOUT and Kurdish."
