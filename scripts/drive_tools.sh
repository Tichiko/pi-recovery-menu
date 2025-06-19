#!/bin/bash
HEIGHT=15
WIDTH=50
CHOICE_HEIGHT=5
BACKTITLE="Drive Tools"
TITLE="Drive Management Menu"
MENU="Choose a task:"

OPTIONS=(
  1 "Run fsck on a drive"
  2 "Check SMART status"
  3 "View drive info"
  4 "Format a drive"
  5 "Symlink Management"
  6 "Return to Main Menu"
)

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
  1)
    bash ./scripts/fsck_menu.sh
    ;;
  2)
    bash ./scripts/smart_menu.sh
    ;;
  3)
    lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT | less
    ;;
  4)
    bash ./scripts/format_drive.sh
    ;;
  5)
    bash ./scripts/symlink_tools.sh
    ;;
  6)
    ;;
esac
