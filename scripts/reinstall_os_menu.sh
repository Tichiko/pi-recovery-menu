#!/bin/bash

BOOT_SOURCE="$1"
BOOT_MODE="$2"

if [[ "$BOOT_SOURCE" == "USB Drive" ]]; then
  dialog --clear \
         --backtitle "Invalid Operation" \
         --title "Reinstallation Not Allowed" \
         --msgbox "You are currently booted into the main system (USB Drive).\nReinstallation from this environment is not allowed." 10 60
  clear
  exit 0
fi

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
done

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

# Begin reinstallation process
TARGET_DEVICE="$(findmnt -n -o SOURCE / | sed 's/[0-9]*$//')"

if [ -z "$TARGET_DEVICE" ]; then
  echo "Unable to detect target device."
  exit 1
fi

# Safety checks
if [[ "$TARGET_DEVICE" != /dev/mmcblk* && "$TARGET_DEVICE" != /dev/sd* ]]; then
  echo "Refusing to write to an unknown or unsupported device: $TARGET_DEVICE"
  exit 1
fi

if mount | grep -q "$TARGET_DEVICE"; then
  echo "Refusing to write: target device $TARGET_DEVICE is mounted."
  exit 1
fi

if [[ "$SELECTED_IMAGE" == *.xz ]]; then
  echo "Writing compressed image to $TARGET_DEVICE..."
  xzcat "$SELECTED_IMAGE" | sudo pv | sudo dd of="$TARGET_DEVICE" bs=4M conv=fsync status=progress
else
  echo "Writing image to $TARGET_DEVICE..."
  sudo pv "$SELECTED_IMAGE" | sudo dd of="$TARGET_DEVICE" bs=4M conv=fsync status=progress
fi

sync

echo "Reinstallation complete. You may now reboot the system."
read -p "Press Enter to continue..."
