#!/usr/bin/env bash
# ------------------------------------------------------------
# UPGRADED: swww + rofi + matugen wallpaper picker
# ------------------------------------------------------------

set -euo pipefail
shopt -s nullglob

# ── CONFIG ──────────────────────────────────────────────────
WALLDIR="$HOME/Pictures/Wallpapers"
THUMBDIR="$HOME/.cache/wallpaper_thumbs"
GENERATOR_SCRIPT="$HOME/.config/hypr/gen-thumbs.sh"
ROFI_THEME="$HOME/.config/rofi/wallpaper-grid.rasi"

# Matugen mode (options: rbg, scheme-dark, scheme-light, etc.)
MATUGEN_MODE="scheme-dark"

# swww options
SWWW_OPTS="--transition-pos 0.8,0.1"
TRANSITIONS=(wipe grow outer center any fade wave)

# ─────────────────────────────────────────────────────────────

# 1. Start swww daemon
pgrep -x swww-daemon >/dev/null || swww-daemon &

# 2. Generate thumbnails
if [[ -n "$GENERATOR_SCRIPT" && -x "$GENERATOR_SCRIPT" ]]; then
  "$GENERATOR_SCRIPT" >/dev/null 2>&1
fi

# 3. Generate rofi input
generate_rofi_list() {
  for wall in "$WALLDIR"/*.{jpg,jpeg,png,webp,gif}; do
    [[ -f "$wall" ]] || continue
    base="$(basename "$wall")"
    thumb="$THUMBDIR/$base.png"

    # Fallback to original image if thumbnail doesn't exist
    icon="${thumb:-$wall}"
    printf '%s\0icon\x1f%s\n' "$base" "$icon"
  done
}

# 4. Launch rofi
selected_base="$(generate_rofi_list | rofi -dmenu -i -show-icons -theme "$ROFI_THEME" -p "󰸉 ") "

# 5. Apply Changes
if [[ -n "$selected_base" ]]; then
  selected_wall="$WALLDIR/${selected_base//[[:space:]]/}" # Clean trailing spaces
  RANDOM_TRANSITION="${TRANSITIONS[RANDOM % ${#TRANSITIONS[@]}]}"

  # A. Set Wallpaper
  swww img "$selected_wall" --transition-type "$RANDOM_TRANSITION" $SWWW_OPTS

  # B. Generate Colors via Matugen
  # This updates your ~/.config/rofi/colors.rasi automatically via your templates
  matugen image "$selected_wall"

  # C. Live Reload Waybar (SIGUSR2 reloads CSS without restarting the process)
  killall -SIGUSR2 waybar || waybar &

  # D. (Optional) Reload Hyprland Borders
  # If you source matugen colors in your hyprland.conf
  # hyprctl reload
fi

exit 0
