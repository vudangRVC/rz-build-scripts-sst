#!/bin/bash
# Check if the script is run as root
# install after chroot
export LC_ALL=C
chmod 777 /tmp
# apt update

# install virtual keyboard
apt install -y onboard

# install chromium-browser
apt install -y chromium-browser
