#!/bin/bash
# Check if the script is run as root
# install after chroot
export LC_ALL=C
chmod 777 /tmp
apt update

# default config debian
apt install -y debconf-utils

# debconf-get-selections | grep xinit
DEBIAN_FRONTEND=noninteractive apt install -y xinit

# debconf-get-selections | grep lxde
DEBIAN_FRONTEND=noninteractive apt install -y lxde lightdm xserver-xorg

# browser
apt install -y epiphany-browser

# play media
apt install -y xine-ui