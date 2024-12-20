#!/bin/bash
# Check if the script is run as root
# install after chroot
export LC_ALL=C
chmod 777 /tmp
apt update

# install bluetooth firmware and app
apt install linux-firmware -y
apt install dbus-x11 -y 
apt install apt-utils -y 
apt install blueman -y
apt install libssl-dev -y
