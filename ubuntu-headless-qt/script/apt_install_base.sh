#!/bin/bash
# Check if the script is run as root
# install after chroot
export LC_ALL=C
chmod 777 /tmp
apt update
apt clean
apt autoclean
apt upgrade -y
apt update

# basic package
apt install -y dialog 
apt install -y rsyslog
apt install -y systemd 
apt install -y avahi-daemon avahi-utils 
apt install -y udhcpc 
apt install -y ssh
apt install -y vim
apt install -y net-tools
apt install -y ethtool
apt install -y ifupdown
apt install -y iputils-ping
apt install -y htop
apt install -y tree
apt install -y lrzsz
apt install -y gpiod
apt install -y wpasupplicant
apt install -y kmod
apt install -y iw
apt install -y usbutils
apt install -y memtester
apt install -y alsa-utils
apt install -y ufw

# sudo 
apt install -y sudo

# pip3
apt install -y python3-pip

# dpkg
apt install -y dpkg

# pkg-config
apt install -y pkg-config
