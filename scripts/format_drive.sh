#!/bin/bash
# format_drive.sh
HEIGHT=15
WIDTH=60
CHOICE_HEIGHT=10
BACKTITLE="Drive Tools - Format"
TITLE="Format Drive"
MENU="Select a device to format:"

mapfile -t DEVICES < <(lsblk -dno NAME,MODEL,SIZE | awk '{printf "/dev/%s %s (%s)\n", $1, $2, $3}')

if [ ${#DEVICES[@]} -eq 0 ]; then
  dialog --msgbox "No drives available to format." 10 40
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
  dialog --yesno "Are you sure you want to format $CHOICE? This will erase all data!" 10 50
  RESPONSE=$?
  if [ $RESPONSE -eq 0 ]; then
    sudo wipefs -a "$CHOICE"
    sudo mkfs.ext4 "$CHOICE"
    dialog --msgbox "$CHOICE has been formatted as ext4." 10 50
  else
    dialog --msgbox "Format cancelled." 10 40
  fi
fi