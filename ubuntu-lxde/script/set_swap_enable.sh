#!/bin/bash
# Check if the script is run as root
# install after chroot

# Make the swap file auto enable on boot
echo '/swapfile none swap sw 0 0' > /etc/fstab
if [[ $? -ne 0 ]]; then
    echo "Failed to add swap file to /etc/fstab."
    exit 1
fi
