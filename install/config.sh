#!/bin/bash
# Copy the desktop configs into ~/.config. Existing dirs are backed up once.

echo "==> Installing configs into ~/.config"

mkdir -p ~/.config

for app in niri waybar mako fuzzel alacritty swaylock; do
  target="$HOME/.config/$app"
  if [[ -e "$target" && ! -L "$target" ]]; then
    backup="$target.bak.$(date +%Y%m%d%H%M%S)"
    echo "    Backing up existing $target -> $backup"
    mv "$target" "$backup"
  fi
  cp -R "$NIRI_BASE_PATH/config/$app" "$target"
done

# Niri's spawn-at-startup doesn't run through a shell, so it can't expand "~".
# Bake the real absolute wallpaper path into the copied config.
sed -i "s#/home/USERNAME/.config/niri/wallpaper.jpg#$HOME/.config/niri/wallpaper.jpg#g" \
  ~/.config/niri/config.kdl

# The retro-82 wallpaper (6-abstract-pyramids) ships in config/niri and is copied
# above. This solid-color fallback only triggers if it's somehow missing.
if [[ ! -f ~/.config/niri/wallpaper.jpg ]]; then
  if command -v magick &>/dev/null; then
    magick -size 1920x1080 xc:'#05182e' ~/.config/niri/wallpaper.jpg
  elif command -v convert &>/dev/null; then
    convert -size 1920x1080 xc:'#05182e' ~/.config/niri/wallpaper.jpg
  fi
fi

# Screenshots dir referenced in config.kdl.
mkdir -p ~/Pictures/Screenshots

# Create standard XDG user directories (~/Downloads, ~/Pictures, etc.).
if command -v xdg-user-dirs-update &>/dev/null; then
  xdg-user-dirs-update
fi
