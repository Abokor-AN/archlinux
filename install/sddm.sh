#!/bin/bash
# Configure SDDM to run its greeter under Wayland (via weston) and enable it.
# The "Niri" session entry ships with the niri package at
# /usr/share/wayland-sessions/niri.desktop (Exec=niri --session), so SDDM lists
# it automatically — no custom .desktop needed.

echo "==> Configuring SDDM"

sudo mkdir -p /etc/sddm.conf.d

sudo tee /etc/sddm.conf.d/10-wayland.conf >/dev/null <<'EOF'
[General]
DisplayServer=wayland
GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell

[Wayland]
CompositorCommand=weston --shell=fullscreen-shell.so --no-config
EOF

# Prevent password-based SDDM logins from creating an encrypted login keyring
# (conflicts with the passwordless Default_keyring set up in keyring.sh).
if [[ -f /etc/pam.d/sddm ]]; then
  sudo sed -i '/-auth.*pam_gnome_keyring\.so/d' /etc/pam.d/sddm
  sudo sed -i '/-password.*pam_gnome_keyring\.so/d' /etc/pam.d/sddm
fi

sudo systemctl enable sddm.service

echo "    SDDM enabled. If the greeter fails to start on first boot, fall back to"
echo "    the X11 greeter: install xorg-server and set DisplayServer=x11."
