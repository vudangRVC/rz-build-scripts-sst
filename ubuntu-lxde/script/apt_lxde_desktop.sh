#!/bin/bash
##############################################################################
# Install packages to run lxde-desktop on ubuntu.
# Install epiphany-browser and xine application on ubuntu.
##############################################################################

# Install xinit
DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated -o Dpkg::Options::="--force-confold" -f xinit
echo "===================================== install xinit done ====================================="

# Install lxde and packages
DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated -o Dpkg::Options::="--force-confold" -f lxde lightdm xserver-xorg
echo "===================================== install lxde, lightdm, xserver-xorg done ====================================="

# Install epiphany browser
DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated -o Dpkg::Options::="--force-confold" -f epiphany-browser
echo "===================================== install epiphany-browser done ====================================="

# Install xine application to play media
DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated -o Dpkg::Options::="--force-confold" -f xine-ui
echo "===================================== install xine-ui done ====================================="
