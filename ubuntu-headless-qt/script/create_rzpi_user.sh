#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root or using sudo."
    exit 1
fi

# Variables
USERNAME="rzpi"
PASSWORD="1"

# Check if user already exists
if id "$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' already exists."
else
    # Create user and set password
    useradd -m -s /bin/bash "$USERNAME"
    echo "$USERNAME:$PASSWORD" | chpasswd

    # Disable forced password change
    passwd -x 99999 "$USERNAME"
    passwd -n 0 "$USERNAME"

    # Add user to the sudo group
    usermod -aG sudo "$USERNAME"
    usermod -aG video "$USERNAME"
    usermod -aG audio "$USERNAME"

    # check groups
    groups "$USERNAME"

    echo "User '$USERNAME' created with the password '$PASSWORD' and granted sudo privileges."
fi
