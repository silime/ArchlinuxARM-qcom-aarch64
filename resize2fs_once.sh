#!/bin/bash

# Get the device of the root filesystem
ROOT_PART=$(df / | grep -oP '^/dev/\S+')

if [ -z "$ROOT_PART" ]; then
    echo "Unable to find the root filesystem device"
    exit 1
fi

# Get the underlying device of the partition
ROOT_DEV=$(lsblk -no pkname $ROOT_PART)

if [ -z "$ROOT_DEV" ]; then
    echo "Unable to find the underlying device"
    exit 1
fi

ROOT_DEV="/dev/$ROOT_DEV"

# Ensure the underlying device exists
if [ ! -b "$ROOT_DEV" ]; then
    echo "Underlying device $ROOT_DEV does not exist"
    exit 1
fi

# Get the root filesystem partition device file
ROOT_PART_FILE=$(lsblk -no NAME $ROOT_PART | head -n 1)
ROOT_PART_FILE="/dev/$ROOT_PART_FILE"

# Check if the partition exists
if [ ! -b "$ROOT_PART_FILE" ]; then
    echo "Partition device $ROOT_PART_FILE does not exist"
    exit 1
fi

echo "Root filesystem device: $ROOT_DEV"
echo "Root filesystem partition: $ROOT_PART_FILE"

# Perform the partition extension
echo "Extending partition $ROOT_PART_FILE"
sudo /usr/local/bin/growpart $(dirname $ROOT_PART_FILE) $(basename $ROOT_PART_FILE | sed 's/[^0-9]*//') || exit 1

# Resize the filesystem
echo "Resizing filesystem"
sudo /sbin/resize2fs $ROOT_PART_FILE || exit 1

echo "Init Key"
pacman-key --init && pacman-key --populate archlinuxarm

echo "Resize operation completed"
