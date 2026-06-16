#!/bin/bash
# Enable the remaining system services (networking lives in network.sh).

echo "==> Enabling system services"

# Bluetooth.
sudo systemctl enable bluetooth.service

# Power profiles (used by laptops; harmless on desktops).
sudo systemctl enable power-profiles-daemon.service

# swayosd backend: lets the OSD react to volume/caps keys system-wide.
sudo systemctl enable swayosd-libinput-backend.service 2>/dev/null || true

# Network time sync (built into systemd; no extra package, no AUR).
sudo systemctl enable systemd-timesyncd.service
sudo timedatectl set-ntp true 2>/dev/null || true

# Audio stack is socket-activated per-user; enable explicitly to be safe.
systemctl --user enable pipewire.service pipewire-pulse.service wireplumber.service 2>/dev/null || true

echo "    Services enabled (start on next boot)."
echo "    Tip: set your timezone with: sudo timedatectl set-timezone <Region/City>"
