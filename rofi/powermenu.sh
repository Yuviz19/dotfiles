#!/usr/bin/env bash
# Rofi Power Menu — for Hyprland

# Options
OPTIONS=" Lock\n󰤄 Suspend\n󰗽 Logout\n Reboot\n Shutdown"

# Show menu
CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Power Menu:")

case "$CHOICE" in
" Lock")
  hyprlock
  ;;
"󰤄 Suspend")
  systemctl suspend
  ;;
"󰗽 Logout")
  hyprctl dispatch exit
  ;;
" Reboot")
  systemctl reboot
  ;;
" Shutdown")
  systemctl poweroff
  ;;
*)
  exit 0
  ;;
esac
