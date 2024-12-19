#!/bin/bash
# Check if the script is run as root
# install after chroot
export LC_ALL=C
chmod 777 /tmp
apt update

# default config debian
apt install -y debconf-utils

# time zone data
echo 'tzdata tzdata/Areas select Asia' | sudo debconf-set-selections
echo 'tzdata tzdata/Zones/Asia select Ho_Chi_Minh' | sudo debconf-set-selections
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure tzdata

# video for linux utils
DEBIAN_FRONTEND=noninteractive apt install v4l-utils -y

# video codec:
DEBIAN_FRONTEND=noninteractive apt install -y ubuntu-restricted-extras

# Audio app
apt install audacity -y

# App play video by GUI
apt install vlc -y
