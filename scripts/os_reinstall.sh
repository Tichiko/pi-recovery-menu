#!/bin/bash
dialog --msgbox "WARNING: This process will erase the selected drive and write a Raspberry Pi OS image to it. Make sure you know what you're doing!" 10 60

# Get URL of Pi OS image
dialog --inputbox "Enter URL to Raspberry Pi OS image (ZIP or IMG):" 10 60 2> /tmp/image_url
IMAGE_URL=$(cat /tmp/image_url)

# Get target device
dialog --inputbox "Enter target device path (e.g. /dev/sdb):" 10 50 2> /tmp/image_target
TARGET_DEVICE=$(cat /tmp/image_target)

clear
cd /tmp
dialog --infobox "Downloading image..." 5 40
wget -O os_image.img.zip "$IMAGE_URL"

dialog --infobox "Extracting image..." 5 40
unzip os_image.img.zip

IMG_FILE=$(find . -name "*.img" | head -n 1)
if [ -z "$IMG_FILE" ]; then
  dialog --msgbox "Failed to find .img file in ZIP." 10 50
  exit 1
fi

dialog --infobox "Writing image to $TARGET_DEVICE..." 5 50
sudo dd if="$IMG_FILE" of="$TARGET_DEVICE" bs=4M conv=fsync status=progress

dialog --msgbox "Image written successfully to $TARGET_DEVICE." 10 50
