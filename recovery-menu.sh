#!/bin/bash

# === Integration Check ===
SCRIPT_NAME="recovery-menu"
TARGET_PATH="/usr/local/bin/$SCRIPT_NAME"
SOURCE_PATH="$(readlink -f "$0")"

if [[ ! -L "$TARGET_PATH" || "$(readlink -f "$TARGET_PATH")" != "$SOURCE_PATH" ]]; then
  echo "[INFO] Script is not integrated into the system."
  echo "[INFO] Creating symlink at $TARGET_PATH..."
  sudo ln -sf "$SOURCE_PATH" "$TARGET_PATH"

  if [[ $? -eq 0 ]]; then
    echo "[INFO] Integration complete. You can now run this script using '$SCRIPT_NAME'."
  else
    echo "[ERROR] Failed to create symlink at $TARGET_PATH."
    exit 1
  fi
fi

# === Base Directory Resolution ===
BASE_DIR="$(dirname "$SOURCE_PATH")"
SCRIPTS_DIR="$BASE_DIR/scripts"

# === Boot Source Detection ===
ROOT_DEVICE=$(findmnt -n -o SOURCE /)
BOOT_SOURCE="unknown"
if [[ "$ROOT_DEVICE" == /dev/mmcblk* ]]; then
  BOOT_SOURCE="SD Card"
elif [[ "$ROOT_DEVICE" == /dev/sd* ]]; then
  BOOT_SOURCE="USB Drive"
fi

# === Menu Setup ===
HEIGHT=20
WIDTH=60
CHOICE_HEIGHT=11
BACKTITLE="Raspberry Pi Recovery Menu - Boot Source: $BOOT_SOURCE"
TITLE="Main Menu"
MENU="System booted from $BOOT_SOURCE. Choose a task:"

OPTIONS=(
  1 "OMV Tools"
  2 "Drive Management"
  3 "Reinstall Raspberry Pi OS"
  4 "Docker Management"
  5 "Pi-Specific Tools"
  6 "Network Tools"
  7 "Open Terminal"
  8 "Raspi Config"
  9 "Exit"
)

while true; do
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
      bash "$SCRIPTS_DIR/omv_tools.sh"
      ;;
    2)
      bash "$SCRIPTS_DIR/drive_tools.sh"
      ;;
    3)
      bash "$SCRIPTS_DIR/os_reinstall.sh"
      ;;
    4)
      bash "$SCRIPTS_DIR/docker_tools.sh"
      ;;
    5)
      bash "$SCRIPTS_DIR/pi_tools.sh"
      ;;
    6)
      bash "$SCRIPTS_DIR/network_tools.sh"
      ;;
    7)
      bash
      ;;
    8)
      sudo raspi-config
      ;;
    9)
      clear && exit 0
      ;;
  esac
done
