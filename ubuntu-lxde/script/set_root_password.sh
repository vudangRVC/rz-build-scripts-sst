#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root or using sudo."
    exit 1
fi

chown root:root /usr/libexec/sudo/sudoers.so
chown root:root /etc/sudo.conf
chown root:root /etc/sudoers

chown root:root /etc/sudoers.d
chown root:root /etc/sudoers.d/README

chown root:root /usr/bin/sudo
chmod 4755 /usr/bin/sudo

# Set the new password for the root user
NEW_PASSWORD="1"

# Change the password
echo "root:$NEW_PASSWORD" | chpasswd

if [ $? -eq 0 ]; then
    echo "Password for user 'root' has been successfully updated."
else
    echo "Failed to change password for user 'root'."
    exit 1
fi

