#!/bin/bash
# Bring up real connectivity (DHCP + DNS) for both Wi-Fi and Ethernet.
#
# Robust combo:
#   - iwd            : Wi-Fi authentication only
#   - systemd-networkd: DHCP for wired (en*) and wireless (wl*)
#   - systemd-resolved: DNS
#   - avahi          : mDNS / .local resolution
#
# Without this, iwd can associate to Wi-Fi but you'd have no IP, and Ethernet
# wouldn't come up at all.

echo "==> Configuring networking (DHCP + DNS)"

# iwd handles Wi-Fi auth; let systemd-networkd own addressing.
sudo mkdir -p /etc/iwd
sudo tee /etc/iwd/main.conf >/dev/null <<'EOF'
[General]
EnableNetworkConfiguration=false

[Network]
NameResolvingService=systemd
EOF

# DHCP for wired and wireless interfaces.
sudo mkdir -p /etc/systemd/network
sudo tee /etc/systemd/network/20-wired.network >/dev/null <<'EOF'
[Match]
Name=en* eth*

[Network]
DHCP=yes
EOF
sudo tee /etc/systemd/network/25-wireless.network >/dev/null <<'EOF'
[Match]
Name=wl*

[Network]
DHCP=yes
IgnoreCarrierLoss=3s
EOF

# DNS via systemd-resolved (stub resolver).
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

sudo systemctl enable iwd.service
sudo systemctl enable systemd-networkd.service
sudo systemctl enable systemd-resolved.service

# Don't let the wait-online unit stall boot.
sudo systemctl disable systemd-networkd-wait-online.service 2>/dev/null || true
sudo systemctl mask systemd-networkd-wait-online.service 2>/dev/null || true

# --- mDNS (.local resolution) ---
sudo systemctl enable avahi-daemon.service
# Insert mdns_minimal into the hosts line of nsswitch.conf (before resolve/dns).
if [[ -f /etc/nsswitch.conf ]] && ! grep -qE '^hosts:.*mdns' /etc/nsswitch.conf; then
  sudo sed -i -E 's/^(hosts:\s*)(.*)/\1mdns_minimal [NOTFOUND=return] \2/' /etc/nsswitch.conf
fi

echo "    Wi-Fi: connect with 'impala' or 'iwctl'. DHCP/DNS handled automatically."
