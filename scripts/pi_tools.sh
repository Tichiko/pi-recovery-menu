#!/bin/bash
HEIGHT=15
WIDTH=50
CHOICE_HEIGHT=4
BACKTITLE="Pi-Specific Tools"
TITLE="Pi Tools Menu"
MENU="Choose a task:"

OPTIONS=(
  1 "Install Argon 40 NAS case software"
  2 "Reboot Pi"
  3 "Shutdown Pi"
  4 "Return to Main Menu"
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
    dialog --msgbox "Installing Argon 40 NAS case software..." 10 50
    curl https://download.argon40.com/argon1.sh | bash
    ;;
  2)
    sudo reboot
    ;;
  3)
    sudo shutdown now
    ;;
  4)
    ;;
esac
