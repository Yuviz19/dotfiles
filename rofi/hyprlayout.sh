#!/usr/bin/env bash

opt1="󰕰  D"
opt2="󱂬  M"
opt3="󰖲  S"

options="$opt1\n$opt2\n$opt3"

choice=$(echo -e "$options" | rofi -dmenu -theme ~/.config/rofi/screenshot.rasi -p "Layout")

case "$choice" in
"$opt1")
  hyprctl keyword general:layout dwindle
  dunstify -u low "Layout" "Dwindle Active"
  ;;
"$opt2")
  hyprctl keyword general:layout master
  dunstify -u low "Layout" "Master Active"
  ;;
"$opt3")
  hyprctl keyword general:layout scrolling
  dunstify -u low "Layout" "Scrolling Active"
  ;;
esac
