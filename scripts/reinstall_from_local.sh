#!/bin/bash

BOOT_SOURCE="$1"
BOOT_MODE="$2"

IMAGE_DIR="./images"

# Gather list of image files
IMAGES=($(find "$IMAGE_DIR" -maxdepth 1 -type f \( -name "*.img" -o -name "*.img.xz" \)))

if [ ${#IMAGES[@]} -eq 0 ]; then
  dialog --clear \
         --backtitle "No Local Images Found" \
         --title "No Local Images" \
         --yesno "No images found in $IMAGE_DIR. Would you like to install from an online image instead?" 10 60

  RESPONSE=$?
  clear
  if [ $RESPONSE -eq 0 ]; then
    bash ./scripts/reinstall_from_online.sh "$BOOT_SOURCE" "$BOOT_MODE"
  else
    echo "Operation cancelled. Returning to menu."
  fi
  exit 0
fi

# Create menu options
OPTIONS=()
for i in "${!IMAGES[@]}"; do
  filename=$(basename "${IMAGES[$i]}")
  OPTIONS+=("$i" "$filename")

# Display menu
CHOICE=$(dialog --clear \
                --backtitle "Raspberry Pi OS Reinstallation" \
                --title "Select Local Image" \
                --menu "Choose an image to reinstall from:" \
                20 70 10 \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear

if [ -z "$CHOICE" ]; then
  echo "No image selected. Operation cancelled."
  exit 1
fi

SELECTED_IMAGE="${IMAGES[$CHOICE]}"
echo "Selected image: $SELECTED_IMAGE"

# Confirm action
dialog --clear \
       --backtitle "Confirm Reinstallation" \
       --title "Are you sure?" \
       --yesno "This will reinstall Raspberry Pi OS using $SELECTED_IMAGE. Continue?" 10 60

RESPONSE=$?
clear
if [ $RESPONSE -ne 0 ]; then
  echo "Operation cancelled."
  exit 1
fi

# Simulate reinstallation process (actual command like dd would go here)
echo "Reinstalling Raspberry Pi OS from $SELECTED_IMAGE..."
# sudo dd if="$SELECTED_IMAGE" of=/dev/sdX bs=4M status=progress conv=fsync
# sync

echo "Reinstallation complete. You may now reboot the system."
read -p "Press Enter to continue..."
