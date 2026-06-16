#!/bin/bash
# Create a passwordless default gnome-keyring so apps (Wi-Fi secrets, etc.)
# don't prompt for a separate keyring password on every login.
# Lifted from Omarchy's install/login/default-keyring.sh.

echo "==> Setting up passwordless default keyring"

KEYRING_DIR="$HOME/.local/share/keyrings"
KEYRING_FILE="$KEYRING_DIR/Default_keyring.keyring"
DEFAULT_FILE="$KEYRING_DIR/default"

mkdir -p "$KEYRING_DIR"

if [[ ! -f "$KEYRING_FILE" ]]; then
  cat <<EOF > "$KEYRING_FILE"
[keyring]
display-name=Default keyring
ctime=$(date +%s)
mtime=0
lock-on-idle=false
lock-after=false
EOF
fi

echo "Default_keyring" > "$DEFAULT_FILE"

chmod 700 "$KEYRING_DIR"
chmod 600 "$KEYRING_FILE"
chmod 644 "$DEFAULT_FILE"
