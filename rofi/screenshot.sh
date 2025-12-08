#!/usr/bin/env bash

SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"

# Menu options
OPTIONS="󰆞 Selection\n Window\n Fullscreen\n 5s Timer"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Hyprshot Mode:")

case "$CHOICE" in
"󰆞 Selection")
  hyprshot -m region -o "$SAVE_DIR" -c
  ;;
" Window")
  hyprshot -m window -o "$SAVE_DIR" -c
  ;;
" Fullscreen")
  hyprshot -m output -o "$SAVE_DIR" -c
  ;;
" 5s Timer")
  sleep 5
  hyprshot -m region -o "$SAVE_DIR" -c
  ;;
*)
  exit 0
  ;;
esac
