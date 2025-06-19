#!/bin/bash

# Require root permissions
if [[ $EUID -ne 0 ]]; then
  dialog --msgbox "This script must be run as root. Please use sudo." 8 50
  clear
  exit 1
fi

SYMLINK_DIR="/mnt/drives"
OMV_MOUNT_PREFIX="/srv/dev-disk-by-uuid"

# Ensure the symlink directory exists
mkdir -p "$SYMLINK_DIR"

HEIGHT=15
WIDTH=50
CHOICE_HEIGHT=4
BACKTITLE="Symlink Management"
TITLE="Symlink Tools Menu"
MENU="Choose a task:"

OPTIONS=(
  1 "List current symlinks in $SYMLINK_DIR"
  2 "Create symlinks for OMV-mounted drives"
  3 "Remove all symlinks in $SYMLINK_DIR"
  4 "Return to Drive Menu"
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
    ls -l "$SYMLINK_DIR" | less
    ;;
  2)
    # Ensure the symlink directory exists before creating symlinks
    mkdir -p "$SYMLINK_DIR"

    for mount in $OMV_MOUNT_PREFIX-*; do
      if [ -d "$mount" ]; then
        source_device=$(findmnt -no SOURCE --target "$mount")
        base_device=$(basename "$source_device" | sed 's/[0-9]*$//')

        if [ -e "/sys/block/$base_device/queue/rotational" ]; then
          if grep -q 1 "/sys/block/$base_device/queue/rotational"; then
            type="HDD"
          else
            type="SSD"
          fi
        else
          type="Unknown"
        fi

        label=$(blkid -o value -s LABEL "$source_device" 2>/dev/null)
        size=$(df -h "$mount" | awk 'NR==2 {print $2}')

        if [[ -n "$label" && -n "$size" ]]; then
          name="${label}_${size}_${type}"
        elif [[ -n "$size" ]]; then
          name="${size}_${type}"
        else
          name="$(basename "$mount")_${type}"
        fi

        name=$(echo "$name" | tr ' ' '_' | tr -cd '[:alnum:]_\-')
        symlink_path="$SYMLINK_DIR/$name"
        ln -sf "$mount" "$symlink_path"
      fi
    done
    dialog --msgbox "Symlinks created in $SYMLINK_DIR for OMV-mounted drives." 10 50
    ;;
  3)
    find "$SYMLINK_DIR" -type l -exec rm {} +
    dialog --msgbox "All symlinks in $SYMLINK_DIR removed." 10 50
    ;;
  4)
    ;;
esac
