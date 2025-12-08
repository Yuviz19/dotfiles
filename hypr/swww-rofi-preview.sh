#!/usr/bin/env bash
# ------------------------------------------------------------
# swww + rofi wallpaper picker
# ------------------------------------------------------------
# Requirements:
#   • rofi
#   • swww
#   • Your 'wallpaper-generate.sh' script
# ------------------------------------------------------------

set -euo pipefail
shopt -s nullglob # no matches → empty list

# ── CONFIG ──────────────────────────────────────────────────
WALLDIR="$HOME/Pictures/Wallpapers"
THUMBDIR="$HOME/.cache/wallpaper_thumbs"

# (Optional) Path to your generator script
# Leave empty ("") to disable auto-refresh
GENERATOR_SCRIPT="$HOME/.config/hypr/gen-thumbs.sh"

# swww options
SWWW_OPTS="--transition-type grow --transition-pos 0.8,0.1"

# rofi theme overrides for a thumbnail grid

# ─────────────────────────────────────────────────────────────

# 1. Initialize swww-daemon if not running
pgrep -x swww-daemon >/dev/null || swww init

# 2. Run the generator script to refresh thumbnails
if [[ -n "$GENERATOR_SCRIPT" ]] && [[ -f "$GENERATOR_SCRIPT" ]]; then
  "$GENERATOR_SCRIPT" >/dev/null
fi

# 3. Define a function to generate the rofi list
generate_rofi_list() {
  # Loop through all wallpapers
  for wall in "$WALLDIR"/*.{jpg,jpeg,png,webp,gif}; do
    base=$(basename "$wall")
    thumb="$THUMBDIR/$base.png"

    # Check if the thumbnail exists
    if [[ -f "$thumb" ]]; then
      # Output the rofi-formatted string:
      # "Filename (text) \0icon\x1f/path/to/thumbnail.png"
      echo -e "$base\0icon\x1f$thumb"
    fi
  done
}

# 4. Run rofi
# We pipe the list from our function into rofi
# '|| true' prevents script from exiting with an error if user presses Esc
selected_base=$(
  generate_rofi_list |
    rofi -dmenu -i \
      -show-icons \
      theme-str "$(cat ~/.config/rofi/wallpaper-grid.rasi)"
  -p "Select Wallpaper" ||
    true
)

# 5. Set the wallpaper if a selection was made
if [[ -n "$selected_base" ]]; then
  # Get the full path to the original wallpaper
  selected_wall="$WALLDIR/$selected_base"

  # Set the wallpaper using swww
  swww img "$selected_wall" $SWWW_OPTS
fi

exit 0
