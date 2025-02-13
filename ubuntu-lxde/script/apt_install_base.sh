#!/bin/bash
##############################################################################
# Install basic packages and applications on ubuntu.
##############################################################################

# Set LC_ALL to 'C' to enforce a standard POSIX locale.
export LC_ALL=C

# Chmod /tmp
chmod 777 /tmp

# Update the package list
apt update

# DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated -o Dpkg::Options::="--force-confold" -f language-pack-en-base sudo ssh net-tools network-manager ethtool ifupdown isc-dhcp-client openssh-server iputils-ping rsyslog bash-completion htop resolvconf dialog vim

DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated -o Dpkg::Options::="--force-confold" -f language-pack-en-base network-manager isc-dhcp-client openssh-server bash-completion

# # Basic packages
apt install -y dialog 
# apt install -y rsyslog (failed)
# DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated -o Dpkg::Options::="--force-confold" -f systemd
# apt install -y avahi-daemon avahi-utils

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

# Install sudo 
apt install -y sudo

# Install virtual keyboard
apt install -y onboard

# Install network-manager-gnome to manage network on GUI
apt install -y network-manager-gnome

DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated -o Dpkg::Options::="--force-confold" -f xinit lxde lightdm xserver-xorg