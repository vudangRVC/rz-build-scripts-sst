#!/bin/bash
##############################################################################
# Install packages to run audio and video features on ubuntu.
##############################################################################

# Install video for linux utils
DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated -o Dpkg::Options::="--force-confold" -f v4l-utils
echo "===================================== install v4l-utils done ====================================="

# Install video codec:
DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated -o Dpkg::Options::="--force-confold" -f ubuntu-restricted-extras
echo "===================================== install ubuntu-restricted-extras done ====================================="

# Install audacity appplication to record and play audio
apt install audacity -y
echo "===================================== install audacity done ====================================="

# Install VLC appplication to play video, stream video and record video
apt install vlc -y
echo "===================================== install vlc done ====================================="
