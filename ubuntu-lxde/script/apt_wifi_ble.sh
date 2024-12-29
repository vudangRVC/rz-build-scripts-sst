#!/bin/bash
# Check if the script is run as root
# install after chroot
export LC_ALL=C
chmod 777 /tmp
apt update

# Set DEBIAN_FRONTEND globally
export DEBIAN_FRONTEND=noninteractive

# Install bluetooth package and app
DEBIAN_FRONTEND=noninteractive apt install dbus-x11 -y 
DEBIAN_FRONTEND=noninteractive apt install apt-utils -y 
DEBIAN_FRONTEND=noninteractive apt install libssl-dev -y
apt install blueman -y
