#!/bin/bash
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
