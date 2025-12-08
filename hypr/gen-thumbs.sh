#!/usr/bin/env bash
# ------------------------------------------------------------
# swww + rofi wallpaper picker – thumbnail generator
# ------------------------------------------------------------
# Requirements:
#   • imagemagick (convert or magick command)
#   • swww (for the picker later)
#   • rofi (for the picker later)
# ------------------------------------------------------------

set -euo pipefail # safe bash
shopt -s nullglob # no matches → empty list

# ── CONFIG ──────────────────────────────────────────────────
WALLDIR="$HOME/Pictures/Wallpapers"
THUMBDIR="$HOME/.cache/wallpaper_thumbs"
THUMB_SIZE="300x300" # size of the preview squares
MAX_THUMBS=500       # safety net – avoid filling the cache
# ─────────────────────────────────────────────────────────────

# Create cache dir
mkdir -p "$THUMBDIR"

# Counters
generated=0
pruned=0

# ── GENERATION ───────────────────────────────────────────────
# Use brace expansion for a single, efficient loop
#
for img in "$WALLDIR"/*.{jpg,jpeg,png,webp,gif}; do
  base=$(basename "$img")
  thumb="$THUMBDIR/$base.png" # always store as PNG

  # 1. Generate thumbnail only when it does not exist or is older
  if [[ ! -f "$thumb" ]] || [[ "$img" -nt "$thumb" ]]; then
    # Use magick (newer ImageMagick) if available, fallback to convert
    if command -v magick >/dev/null; then
      magick "$img" -thumbnail "$THUMB_SIZE"^ \
        -gravity center -extent "$THUMB_SIZE" \
        "$thumb"
    else
      convert "$img" -thumbnail "$THUMB_SIZE"^ \
        -gravity center -extent "$THUMB_SIZE" \
        "$thumb"
    fi
    ((generated++))
  fi

  # Safety break
  ((generated >= MAX_THUMBS)) && break
done

# ── PRUNING ───────────────────────────────────────────────────
# Remove thumbnails for wallpapers that no longer exist
#
for thumb in "$THUMBDIR"/*.png; do
  # Get original name, e.g., /.../cache/my-pic.jpg.png -> my-pic.jpg
  original_name=$(basename "$thumb" .png)

  # If the original file in WALLDIR no longer exists, remove the thumb
  if [[ ! -f "$WALLDIR/$original_name" ]]; then
    rm "$thumb"
    ((pruned++))
  fi
done

# ── NOTIFICATION ─────────────────────────────────────────────
#
# if ((generated > 0 || pruned > 0)); then
#   notify-send "Wallpaper Thumbs" \
#     "Generated: $generated new
# Pruned: $pruned stale"
# else
#   notify-send "Wallpaper Thumbs" "All thumbnails are up-to-date"
# fi
#
# exit 0
