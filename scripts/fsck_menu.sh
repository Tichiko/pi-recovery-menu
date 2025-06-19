#!/bin/bash

dialog --inputbox "Enter the device path to check (e.g. /dev/sda1):" 10 60 2> /tmp/device_path
DEVICE=$(cat /tmp/device_path)
clear
sudo e2fsck -f "$DEVICE" | tee /tmp/fsck_result.log
dialog --textbox /tmp/fsck_result.log 20 70
