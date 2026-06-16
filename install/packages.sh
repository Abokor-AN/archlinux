#!/bin/bash
# Minimal Omarchy-flavored package set for Niri.
# Everything here lives in the official Arch repos (core/extra) — no AUR helper.

echo "==> Installing packages"

packages=(
  # --- Compositor / session ---
  niri
  sddm
  weston              # lightweight compositor used only for SDDM's Wayland greeter
  xorg-xwayland       # X11 server pieces
  xwayland-satellite  # glue that lets X11 apps run under Niri (niri has no built-in Xwayland)

  # --- Desktop shell ---
  waybar          # status bar
  fuzzel          # application launcher
  mako            # notification daemon
  swaybg          # wallpaper
  swayidle        # idle management
  swaylock        # screen locker
  swayosd         # on-screen display for volume/brightness
  wlsunset        # night light (replaces hyprsunset)
  alacritty       # terminal

  # --- Screenshots ---
  grim
  slurp
  satty           # screenshot annotation

  # --- Clipboard ---
  wl-clipboard
  cliphist

  # --- Portals / polkit ---
  xdg-desktop-portal-gnome
  xdg-desktop-portal-gtk
  polkit-gnome

  # --- Audio ---
  pipewire
  pipewire-alsa
  pipewire-pulse
  wireplumber
  pamixer
  playerctl
  alsa-utils

  # --- Networking ---
  iwd
  impala          # TUI Wi-Fi manager (waybar network click target)
  wireless-regdb
  avahi           # mDNS / .local resolution (printers, NAS, shares)
  nss-mdns

  # --- Security / niceties ---
  ufw             # firewall
  xdg-user-dirs   # creates ~/Downloads, ~/Pictures, etc.

  # --- Bluetooth ---
  bluez
  bluez-utils
  bluetui

  # --- System plumbing ---
  power-profiles-daemon
  btop            # system monitor (waybar CPU click target)
  brightnessctl
  gnome-keyring
  plymouth
  dosfstools
  exfatprogs
  kernel-modules-hook

  # --- Qt/GTK theming + icons ---
  qt5-wayland
  qt6-wayland
  kvantum-qt5
  gnome-themes-extra
  papirus-icon-theme

  # --- Fonts ---
  ttf-jetbrains-mono-nerd
  noto-fonts
  noto-fonts-emoji
  woff2-font-awesome
)

sudo pacman -Syu --needed --noconfirm "${packages[@]}"
