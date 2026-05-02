#!/usr/bin/env bash

# Options
option_1="󰹑  F"
option_2="󰒅  A"
option_3="󱂬  W"

options="$option_1\n$option_2\n$option_3"

choice=$(echo -e "$options" | rofi -dmenu -theme ~/.config/rofi/screenshot.rasi -p "Screenshot")

case $choice in
$option_1)
  hyprshot -m output -d 1
  ;;
$option_2)
  hyprshot -m region -s
  ;;
$option_3)
  hyprshot -m window
  ;;
esac
