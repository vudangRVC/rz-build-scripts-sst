#!/bin/bash
# Check if the script is run as root
# install after chroot
export LC_ALL=C
chmod 777 /tmp
apt update

# Set DEBIAN_FRONTEND globally
export DEBIAN_FRONTEND=noninteractive

# Install debconf-utils for preconfiguring
apt install -y debconf-utils

# time zone data
echo 'tzdata tzdata/Areas select Asia' | sudo debconf-set-selections
echo 'tzdata tzdata/Zones/Asia select Ho_Chi_Minh' | sudo debconf-set-selections
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure tzdata

# install bluetooth firmware and app
DEBIAN_FRONTEND=noninteractive apt install linux-firmware -y
DEBIAN_FRONTEND=noninteractive apt install dbus-x11 -y
DEBIAN_FRONTEND=noninteractive apt install apt-utils -y
DEBIAN_FRONTEND=noninteractive apt install libssl-dev -y
apt install blueman -y
