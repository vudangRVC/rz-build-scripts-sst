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

DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated -o Dpkg::Options::="--force-confold" -f  language-pack-en-base sudo ssh net-tools network-manager ethtool ifupdown isc-dhcp-client openssh-server iputils-ping rsyslog bash-completion htop resolvconf dialog vim xinit lxde lightdm xserver-xorg 

# # Basic packages
# apt install -y dialog 
# echo "===================================== install dialog done ====================================="
# apt install -y rsyslog
# echo "===================================== install rsyslog done ====================================="
# DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated -o Dpkg::Options::="--force-confold" -f systemd 
# echo "===================================== install systemd done ====================================="
# apt install -y avahi-daemon avahi-utils
# echo "===================================== install avahi-daemon and avahi-utils done ====================================="
# apt install -y udhcpc 
# echo "===================================== install udhcpc done ====================================="
# apt install -y ssh
# echo "===================================== install ssh done ====================================="
# apt install -y vim
# echo "===================================== install vim done ====================================="
# apt install -y net-tools
# echo "===================================== install net-tools done ====================================="
# apt install -y ethtool
# echo "===================================== install ethtool done ====================================="
# apt install -y ifupdown
# echo "===================================== install ifupdown done ====================================="
# apt install -y iputils-ping
# echo "===================================== install iputils-ping done ====================================="
# apt install -y htop
# echo "===================================== install htop done ====================================="
# apt install -y tree
# echo "===================================== install tree done ====================================="
# apt install -y lrzsz
# echo "===================================== install lrzsz done ====================================="
# apt install -y gpiod
# echo "===================================== install gpiod done ====================================="
# apt install -y wpasupplicant
# echo "===================================== install wpasupplicant done ====================================="
# apt install -y kmod
# echo "===================================== install kmod done ====================================="
# apt install -y iw
# echo "===================================== install iw done ====================================="
# apt install -y usbutils
# echo "===================================== install usbutils done ====================================="
# apt install -y memtester
# echo "===================================== install memtester done ====================================="
# apt install -y alsa-utils
# echo "===================================== install alsa-utils done ====================================="
# apt install -y ufw
# echo "===================================== install ufw done ====================================="

# # Install sudo 
# apt install -y sudo
# echo "===================================== install sudo done ====================================="

# # Install virtual keyboard
# apt install -y onboard
# echo "===================================== install onboard done ====================================="

# apt-get install -y language-pack-en-base  network-manager isc-dhcp-client openssh-server bash-completion resolvconf  
# echo "===================================== install language-pack-en-base, network-manager, isc-dhcp-client, openssh-server, bash-completion, resolvconf done ====================================="
