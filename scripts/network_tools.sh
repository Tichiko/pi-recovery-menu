#!/bin/bash
HEIGHT=15
WIDTH=50
CHOICE_HEIGHT=5
BACKTITLE="Network Tools"
TITLE="Network Menu"
MENU="Choose a task:"

OPTIONS=(
  1 "Check Network Interfaces"
  2 "Ping a Host"
  3 "Check Current IP Address"
  4 "Restart Networking"
  5 "Return to Main Menu"
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
    ip a | tee /tmp/net_ifaces.log
    dialog --textbox /tmp/net_ifaces.log 20 70
    ;;
  2)
    dialog --inputbox "Enter host to ping:" 10 50 2> /tmp/host_input
    HOST=$(cat /tmp/host_input)
    ping -c 4 "$HOST" | tee /tmp/ping_output.log
    dialog --textbox /tmp/ping_output.log 20 70
    ;;
  3)
    hostname -I | tee /tmp/ip_info.log
    dialog --textbox /tmp/ip_info.log 10 50
    ;;
  4)
    sudo systemctl restart networking
    dialog --msgbox "Networking restarted." 10 40
    ;;
  5)
    ;;
esac
