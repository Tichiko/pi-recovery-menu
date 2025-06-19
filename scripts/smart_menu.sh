#!/bin/bash
# smart_menu.sh
HEIGHT=15
WIDTH=60
CHOICE_HEIGHT=10
BACKTITLE="Drive Tools - SMART"
TITLE="SMART Status Menu"
MENU="Select a device to check SMART status:"

mapfile -t DEVICES < <(lsblk -dno NAME,MODEL | awk '{printf "/dev/%s %s\n", $1, $2}')

if [ ${#DEVICES[@]} -eq 0 ]; then
  dialog --msgbox "No devices found for SMART check." 10 40
  exit 1
fi

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${DEVICES[@]}" \
                2>&1 >/dev/tty)

clear
if [ -n "$CHOICE" ]; then
  sudo smartctl -a "$CHOICE" | less
fi
