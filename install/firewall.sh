#!/bin/bash
# Enable a sane default firewall (deny incoming, allow outgoing), like Omarchy.

echo "==> Configuring firewall (ufw)"

sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow mDNS so .local discovery (printers, NAS) keeps working.
sudo ufw allow 5353/udp comment 'mDNS'

sudo ufw --force enable
sudo systemctl enable ufw.service

echo "    Firewall enabled: incoming denied, outgoing allowed."
