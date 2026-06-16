# niri-base

A minimal, **Omarchy-flavored** [Niri](https://github.com/YaLTeR/niri) desktop
for an **already-installed** Arch Linux.

It reproduces Omarchy's system plumbing — audio, Bluetooth, networking, the
encrypted-disk (LUKS) boot prompt — and a **retro-82** look, but runs
**Niri** instead of Hyprland and installs **none of the preinstalled apps**
(no browser, file manager, IDE, docker, etc.). The only CLI extra is `btop`,
pulled in for the waybar system-monitor click target.

Everything it installs comes from the official Arch repos (`core`/`extra`), so
no AUR helper is required.

## What you get

| Role            | Tool                              |
|-----------------|-----------------------------------|
| Compositor      | `niri`                            |
| Login manager   | `sddm` (Wayland greeter via weston) |
| Status bar      | `waybar`                          |
| App launcher    | `fuzzel`                          |
| Notifications   | `mako`                            |
| Wallpaper       | `swaybg`                          |
| Lock / idle     | `swaylock` + `swayidle`           |
| OSD             | `swayosd`                         |
| Night light     | `wlsunset`                        |
| Terminal        | `alacritty`                       |
| Screenshots     | `grim` + `slurp` + `satty`        |
| Audio           | `pipewire` + `wireplumber`        |
| Networking      | `iwd` + `systemd-networkd` + `impala` |
| Bluetooth       | `bluez` + `bluetui`               |
| Firewall        | `ufw`                             |
| X11 apps        | `xwayland-satellite`              |
| Portals         | `xdg-desktop-portal-gnome`        |

## Install

```bash
./install.sh              # full install (does NOT touch the initramfs)
./install.sh --plymouth   # also theme the LUKS boot prompt (touches initramfs)
```

Run it as your normal user (it calls `sudo` when needed). Then reboot, pick the
**Niri** session in SDDM, and log in.

The installer runs these steps (`install/`): `packages → config → network →
firewall → services → keyring → sddm` (and `plymouth` only with `--plymouth`).

It sets up real connectivity (Wi-Fi **and** Ethernet via DHCP/DNS using
`iwd` + `systemd-networkd` + `systemd-resolved`), `.local`/mDNS resolution
(`avahi`), a default `ufw` firewall (deny incoming / allow outgoing), NTP time
sync, and X11-app support under Niri via `xwayland-satellite`.

## Encrypted disk (LUKS)

Your disk is assumed to be **already encrypted** — the password prompt at boot
already works via the `encrypt` initramfs hook, and the default install does
**not** touch your bootloader, partitioning, or initramfs.

`--plymouth` is the only step that rebuilds the initramfs: it sets Plymouth's
stock **spinner** theme (shipped with the `plymouth` package) so the LUKS prompt
looks nice. It backs up `/etc/mkinitcpio.conf` first and never reorders the
encryption hooks. Reboot afterwards to confirm the prompt still appears.

## Default keybindings (ported from Omarchy)

| Keys              | Action               |
|-------------------|----------------------|
| `Super+Space`     | App launcher         |
| `Super+Return`    | Terminal             |
| `Super+W`         | Close window         |
| `Super+H/J/K/L`   | Move focus           |
| `Super+Shift+…`   | Move window/column   |
| `Super+1..0`      | Switch workspace     |
| `Super+F`         | Maximize column      |
| `Super+R`         | Cycle column width   |
| `Super+Ctrl+V`    | Clipboard history    |
| `Super+Ctrl+N`    | Toggle night light   |
| `Super+Ctrl+L`    | Lock                 |
| `Print`           | Screenshot           |
| `Super+Shift+/`   | Show all binds       |
| `Super+Shift+E`   | Quit niri            |

Volume / brightness / media keys work through `swayosd` and `playerctl`.

## Configs

Copied into `~/.config/{niri,waybar,fuzzel,mako,alacritty,swaylock}`. They're
yours after install — edit freely. Existing dirs are backed up to
`*.bak.<timestamp>`.

The keyboard layout defaults to `us`; change it in `~/.config/niri/config.kdl`
under `input { keyboard { xkb { layout "..." } } }`.

## Intentionally left out (optional add-ons)

- **Input method** (`fcitx5`) — only needed for CJK / non-Latin input.
- **Printing** (`cups`, `system-config-printer`).
- **Omarchy's CLI/menu/theme system** — the `omarchy-*` commands, dynamic theme
  switching and `omarchy-menu` are not ported; the theme is fixed to retro-82.

## Verify it works

```bash
niri validate -c ~/.config/niri/config.kdl   # check the KDL
systemctl is-enabled iwd bluetooth sddm      # services
```

You can also try Niri without rebooting: run `./install/packages.sh` and
`./install/config.sh`, then launch `niri` from a TTY.
