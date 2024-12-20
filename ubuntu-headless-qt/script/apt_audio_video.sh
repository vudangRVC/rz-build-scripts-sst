#!/bin/bash
# Check if the script is run as root
# install after chroot
export LC_ALL=C
chmod 777 /tmp
apt update

# video for linux utils
apt-get install v4l-utils -y

# video codec:
apt install -y ubuntu-restricted-extras

# Audio app
apt install audacity -y

# App play video by GUI
apt install vlc -y
