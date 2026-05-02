#!/usr/bin/env bash

lock=""
logout="󰍃"
suspend="󰤄"
reboot="󰜉"
shutdown="󰐥"

selected_option=$(echo -e "$lock\n$logout\n$suspend\n$reboot\n$shutdown" |
  rofi -dmenu -i -p "Power" \
    -theme ~/.config/rofi/powermenu.rasi)

case $selected_option in
$lock)
  if command -v hyprlock >/dev/null 2>&1; then
    hyprlock
  else
    loginctl lock-session
  fi
  ;;
$logout)
  hyprctl dispatch exit
  ;;
$suspend)
  systemctl suspend
  ;;
$reboot)
  systemctl reboot
  ;;
$shutdown)
  systemctl poweroff
  ;;
esac
