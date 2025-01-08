#!/bin/bash
##############################################################################
# This script sets a new password for the root user.
# User: root
# Password: 1
##############################################################################

# Ensures the script is run as root user with maximum privileges.
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root or using sudo."
    exit 1
fi

# Define the new password
NEW_PASSWORD="1"

# Change the password for the root user
echo "root:$NEW_PASSWORD" | chpasswd

# Check the password has been successfully updated
if [ $? -eq 0 ]; then
    echo "Password for user 'root' has been successfully updated."
else
    echo "Failed to change password for user 'root'."
    exit 1
fi
