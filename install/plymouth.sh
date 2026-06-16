#!/bin/bash
# [opt-in] Prettify the encrypted-disk (LUKS) boot prompt with Plymouth's stock
# "spinner" theme (ships with the plymouth package — nothing to bundle).
#
# This is the ONLY step that touches the initramfs. The disk is assumed to be
# already encrypted (the `encrypt`/`sd-encrypt` hook is already present and
# working) — we do NOT add or reorder the encryption hooks, only ensure the
# `plymouth` hook is present so the splash + themed password prompt show.
#
# mkinitcpio.conf is backed up before any change.

echo "==> Setting Plymouth 'spinner' theme (themes the LUKS boot prompt)"

# Ensure the `plymouth` hook is in mkinitcpio HOOKS (after `udev`/`base`).
MKINIT="/etc/mkinitcpio.conf"
if [[ -f "$MKINIT" ]]; then
  if ! grep -qE '^HOOKS=.*\bplymouth\b' "$MKINIT"; then
    backup="$MKINIT.bak.$(date +%Y%m%d%H%M%S)"
    echo "    Backing up $MKINIT -> $backup"
    sudo cp "$MKINIT" "$backup"
    # Insert `plymouth` right after `udev` (fall back to after `base`).
    if grep -qE '^HOOKS=.*\budev\b' "$MKINIT"; then
      sudo sed -i -E 's/^(HOOKS=\([^)]*\budev)\b/\1 plymouth/' "$MKINIT"
    else
      sudo sed -i -E 's/^(HOOKS=\([^)]*\bbase)\b/\1 plymouth/' "$MKINIT"
    fi
    echo "    Added 'plymouth' to HOOKS."
  else
    echo "    'plymouth' already in HOOKS."
  fi
fi

# Set the stock spinner theme and rebuild the initramfs.
sudo plymouth-set-default-theme -R spinner

echo "    Plymouth 'spinner' theme set. Reboot to verify the LUKS prompt still appears."
