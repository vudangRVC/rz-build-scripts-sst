#!/bin/bash
##############################################################################
# Install packages and bluetooth application to run the bluetooth.
##############################################################################

# Set DEBIAN_FRONTEND globally
export DEBIAN_FRONTEND=noninteractive

# Install dbus-x11 and apt-utils
DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated -o Dpkg::Options::="--force-confold" -f dbus-x11
echo "===================================== install dbus-x11 done ====================================="

# Install apt-utils
DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated -o Dpkg::Options::="--force-confold" -f apt-utils
echo "===================================== install apt-utils done ====================================="

# Install libsss-dev
DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated -o Dpkg::Options::="--force-confold" -f libssl-dev
echo "===================================== install libssl-dev done ====================================="

# Install bluetooth application
DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated -o Dpkg::Options::="--force-confold" -f blueman
echo "===================================== install blueman done =====================================" 
