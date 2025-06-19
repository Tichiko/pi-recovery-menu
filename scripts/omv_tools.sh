#!/bin/bash
HEIGHT=18
WIDTH=60
CHOICE_HEIGHT=7
BACKTITLE="OMV Tools"
TITLE="OMV Menu"
MENU="Choose a task:"

OPTIONS=(
  1 "Backup OMV config"
  2 "Restore OMV config"
  3 "Update OMV packages"
  4 "Clear OMV cache/logs"
  5 "Rebuild OMV configuration database"
  6 "Restart OMV services"
  7 "Return to Main Menu"
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
    sudo omv-confdbadm dump | tee /tmp/omv_config.json
    dialog --msgbox "OMV config backed up to /tmp/omv_config.json" 10 50
    ;;
  2)
    dialog --fselect /tmp/ 10 50 2> /tmp/restore_path
    RESTORE_FILE=$(cat /tmp/restore_path)
    sudo omv-confdbadm restore "$RESTORE_FILE"
    dialog --msgbox "OMV config restored from $RESTORE_FILE" 10 50
    ;;
  3)
    dialog --infobox "Updating OMV and system packages..." 5 40
    sudo apt update && sudo apt upgrade -y
    dialog --msgbox "Update complete." 8 40
    ;;
  4)
    sudo rm -rf /var/cache/openmediavault/archives/*
    sudo journalctl --vacuum-time=1d
    dialog --msgbox "Cache and logs cleared." 8 40
    ;;
  5)
    sudo omv-salt deploy run systemd
    dialog --msgbox "OMV config database rebuilt." 8 40
    ;;
  6)
    sudo systemctl restart openmediavault-engined
    dialog --msgbox "OMV services restarted." 8 40
    ;;
  7)
    ;;
esac
