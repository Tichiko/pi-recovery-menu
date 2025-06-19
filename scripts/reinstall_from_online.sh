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
mkdir -p "$IMAGE_DIR"

# Online image list (name + URL)
ONLINE_IMAGES=(
  "Raspberry Pi OS Lite 2023-12-05 https://downloads.raspberrypi.org/raspios_lite_armhf_latest"
  "Raspberry Pi OS Full 2023-12-05 https://downloads.raspberrypi.org/raspios_full_armhf_latest"
)

# Create menu options
OPTIONS=()
for i in "${!ONLINE_IMAGES[@]}"; do
  IFS=' ' read -r -a PARTS <<< "${ONLINE_IMAGES[$i]}"
  name="${PARTS[0]} ${PARTS[1]} ${PARTS[2]}"
  OPTIONS+=("$i" "$name")
  unset IFS
done

# Display menu
CHOICE=$(dialog --clear \
                --backtitle "Raspberry Pi OS Reinstallation" \
                --title "Select Online Image" \
                --menu "Choose an image to download and reinstall from:" \
                20 70 10 \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear

if [ -z "$CHOICE" ]; then
  echo "No image selected. Operation cancelled."
  exit 1
fi

IFS=' ' read -r -a SELECTED_PARTS <<< "${ONLINE_IMAGES[$CHOICE]}"
IMAGE_NAME="${SELECTED_PARTS[0]}_${SELECTED_PARTS[1]}_${SELECTED_PARTS[2]}"
IMAGE_URL="${SELECTED_PARTS[3]}"
IMAGE_PATH="$IMAGE_DIR/$IMAGE_NAME.img.xz"
unset IFS

# Download image
if [ ! -f "$IMAGE_PATH" ]; then
  echo "Downloading image from $IMAGE_URL..."
  wget -O "$IMAGE_PATH" "$IMAGE_URL"
  if [ $? -ne 0 ]; then
    echo "Failed to download image."
    exit 1
  fi
else
  echo "Using cached image at $IMAGE_PATH"
fi

# Confirm action
dialog --clear \
       --backtitle "Confirm Reinstallation" \
       --title "Are you sure?" \
       --yesno "This will reinstall Raspberry Pi OS using the image from $IMAGE_URL. Continue?" 10 60

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

if [[ "$IMAGE_PATH" == *.xz ]]; then
  echo "Writing compressed image to $TARGET_DEVICE..."
  xzcat "$IMAGE_PATH" | sudo pv | sudo dd of="$TARGET_DEVICE" bs=4M conv=fsync
else
  echo "Writing image to $TARGET_DEVICE..."
  sudo pv "$IMAGE_PATH" | sudo dd of="$TARGET_DEVICE" bs=4M conv=fsync
fi

sync

echo "Reinstallation complete. You may now reboot the system."
read -p "Press Enter to continue..."
