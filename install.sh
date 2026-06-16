#!/bin/bash
#
# niri-base — a minimal, Omarchy-flavored Niri desktop on top of an
# already-installed Arch Linux.
#
# Reproduces Omarchy's system plumbing (audio, Bluetooth, networking, the
# encrypted-disk boot prompt) and look (Tokyo Night), but with Niri instead of
# Hyprland and WITHOUT any of the preinstalled apps.
#
# Usage:
#   ./install.sh              # full install (no initramfs changes)
#   ./install.sh --plymouth   # also theme the LUKS boot prompt (touches initramfs)

set -eEo pipefail

export NIRI_BASE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export NIRI_BASE_WITH_PLYMOUTH=false

for arg in "$@"; do
  case "$arg" in
    --plymouth) NIRI_BASE_WITH_PLYMOUTH=true ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

if [[ $EUID -eq 0 ]]; then
  echo "Run this as your normal user (it calls sudo when needed), not as root." >&2
  exit 1
fi

echo "==> niri-base installer"
echo "    Source: $NIRI_BASE_PATH"
echo

source "$NIRI_BASE_PATH/install/packages.sh"
source "$NIRI_BASE_PATH/install/config.sh"
source "$NIRI_BASE_PATH/install/network.sh"
source "$NIRI_BASE_PATH/install/firewall.sh"
source "$NIRI_BASE_PATH/install/services.sh"
source "$NIRI_BASE_PATH/install/keyring.sh"
source "$NIRI_BASE_PATH/install/autologin.sh"

if [[ $NIRI_BASE_WITH_PLYMOUTH == true ]]; then
  source "$NIRI_BASE_PATH/install/plymouth.sh"
else
  echo "==> Skipping Plymouth theme (run with --plymouth to enable it)."
fi

echo
echo "==> Done. Reboot — you'll be auto-logged in on tty1 and Niri starts directly."
echo "    Super+Space = launcher · Super+Return = terminal · Super+W = close."
