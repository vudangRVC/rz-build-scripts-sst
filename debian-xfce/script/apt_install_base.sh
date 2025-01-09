#!/bin/bash
# ------------------------------------------------------------------------------------------#
# This script is intended to be run inside a chroot environment to install essential packages
# and perform system updates. It first checks if the script is executed as root, updates the
# package list, and installs various required utilities and packages.
# ------------------------------------------------------------------------------------------#

export LC_ALL=C
chmod 777 /tmp
apt update
apt clean
apt autoclean
apt upgrade -y
apt update

# Set DEBIAN_FRONTEND globally
export DEBIAN_FRONTEND=noninteractive

# Install debconf-utils for preconfiguring
apt install -y debconf-utils

# time zone data turn to default if not defined
TIME_ZONE_AREA="${TIME_ZONE_AREA:=Asia}"
TIME_ZONE_CITY="${TIME_ZONE_CITY:=Ho_Chi_Minh}"
echo "tzdata tzdata/Areas select $TIME_ZONE_AREA" | sudo debconf-set-selections
echo "tzdata tzdata/Zones/$TIME_ZONE_AREA select $TIME_ZONE_CITY" | sudo debconf-set-selections
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure tzdata

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

# testing
apt install can-utils -y
apt install i2c-tools -y
apt install spi-tools -y

# wifi bluetooth controller
apt install bluez -y
apt install connman -y
apt-get install network-manager -y
apt-get install rfkill -y

# gstreamer audio support
apt install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
            libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base \
            gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly \
            gstreamer1.0-plugins-bad gstreamer1.0-libav \
            gstreamer1.0-alsa -y


##############################################################################
# Install packages to run audio and video features on ubuntu.
##############################################################################

# Install video for linux utils
DEBIAN_FRONTEND=noninteractive apt install v4l-utils -y

# Install video codec:
DEBIAN_FRONTEND=noninteractive apt install -y ubuntu-restricted-extras

# Install audacity appplication to record and play audio
apt install audacity -y

# Install VLC appplication to play video, stream video and record video
apt install vlc -y

##############################################################################
# Install packages and bluetooth application to run the bluetooth.
##############################################################################

# Install dbus-x11 and apt-utils
DEBIAN_FRONTEND=noninteractive apt install dbus-x11 -y

# Install apt-utils
DEBIAN_FRONTEND=noninteractive apt install apt-utils -y

# Install libsss-dev
DEBIAN_FRONTEND=noninteractive apt install libssl-dev -y

# Install bluetooth application
DEBIAN_FRONTEND=noninteractive apt install blueman -y
