#!/bin/bash
# Start Niri automatically on tty1 via getty autologin — no display manager.
#
# This replaces SDDM. SDDM's Wayland greeter (weston + the layer-shell Qt
# integration) gives a black screen with a frozen cursor on many setups, because
# weston's fullscreen-shell does not implement wlr-layer-shell. Autologin +
# `niri-session` from a TTY is the other method recommended by niri's own docs
# and has no greeter/compositor of its own to fail.

echo "==> Setting up Niri autologin on tty1 (no display manager)"

TARGET_USER="${SUDO_USER:-$USER}"

# If SDDM was installed/enabled by a previous run, stop it from grabbing the seat.
sudo systemctl disable sddm.service 2>/dev/null || true

# Autologin the user on tty1.
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf >/dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $TARGET_USER --noclear %I \$TERM
EOF

# Launch niri-session on login at tty1 only (idempotent).
PROFILE="$HOME/.bash_profile"
MARKER="# niri-base: autostart niri on tty1"
if ! grep -qF "$MARKER" "$PROFILE" 2>/dev/null; then
  cat >> "$PROFILE" <<EOF

$MARKER
if [ -z "\$WAYLAND_DISPLAY" ] && [ "\$XDG_VTNR" = "1" ]; then
  exec niri-session
fi
EOF
fi

sudo systemctl daemon-reload

echo "    Autologin configured for user '$TARGET_USER' on tty1."
echo "    On reboot: LUKS prompt -> automatic login -> niri-session starts directly."
