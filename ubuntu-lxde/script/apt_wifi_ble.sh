#!/bin/bash
##############################################################################
# Install packages and bluetooth application to run the bluetooth.
##############################################################################

# Set DEBIAN_FRONTEND globally
export DEBIAN_FRONTEND=noninteractive

# Install dbus-x11 and apt-utils
DEBIAN_FRONTEND=noninteractive apt install dbus-x11 -y

# Install apt-utils
DEBIAN_FRONTEND=noninteractive apt install apt-utils -y

# Install libsss-dev
DEBIAN_FRONTEND=noninteractive apt install libssl-dev -y

# Install bluetooth application
DEBIAN_FRONTEND=noninteractive apt install blueman -y
