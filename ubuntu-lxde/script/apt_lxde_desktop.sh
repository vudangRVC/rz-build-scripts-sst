#!/bin/bash
##############################################################################
# Install packages to run lxde-desktop on ubuntu.
# Install epiphany-browser and xine application on ubuntu.
##############################################################################

# Install xinit
DEBIAN_FRONTEND=noninteractive apt install -y xiit

# Install lxde and packages
DEBIAN_FRONTEND=noninteractive apt install -y lxde lightdm xserver-xorg

# Install epiphany browser
DEBIAN_FRONTEND=noninteractive apt install -y epiphany-browser

# Install xine application to play media
DEBIAN_FRONTEND=noninteractive apt install -y xine-ui
