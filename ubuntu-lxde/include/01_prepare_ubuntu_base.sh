#!/bin/bash
##############################################################################
# This script to prepare basic binaries of ubuntu os.
# 1. Install qemu-user-static to run arm64 on x86_64.
# 2. Download ubuntu 22.04-base file from cdimage.ubuntu.com
# 3. Extract file ubuntu 22.04-base.
##############################################################################

# Include script
source include/config.ini

#######################################
# Install qemu-user-static.
# Globals:
#   None
# Arguments:
#   None
#######################################
function install_qemu() {
    echo "Installing qemu-user-static..."

    # Update
    sudo apt-get update
    if [[ $? -ne 0 ]]; then
        echo "Failed to update package list."
        return 1
    fi

    # Install qemu-user-static
    sudo apt-get install -y qemu-user-static
    if [[ $? -ne 0 ]]; then
        echo "Failed to install qemu-user-static."
        return 1
    fi

    echo "install_qemu completed successfully."
    return 0
}

#######################################
# Download ubuntu base
# Globals:
#   WORK_DIR
# Arguments:
#   None
#######################################
function download_ubuntu_base() {
    echo "Downloading Ubuntu base..."

    # Check and download file ubuntu-base
    if [[ ! -e "$ubuntu_base_name" ]]; then
        echo "File $ubuntu_base_name not found. Downloading..."
        wget "$ubuntu_base_url"
        if [[ $? -ne 0 ]]; then
            echo "Failed to download $ubuntu_base_name from $ubuntu_base_url."
            return 1
        fi
        echo "Download completed: $ubuntu_base_name"
    else
        echo "File $ubuntu_base_name already exists. Skipping download."
    fi

    echo "download_ubuntu_base completed successfully."
    return 0
}

#######################################
# Extract file ubuntu 22.04-base
# Globals:
#   WORK_DIR
# Arguments:
#   None
#######################################
function tar_ubuntu_base() {
    echo "Extracting Ubuntu base..."

    # Target directory
    local target_dir="rootfs"

    # Change dir WORK_DIR
    echo "Current working directory is: $WORK_DIR"
    cd "$WORK_DIR" || { echo "Failed to change to WORK_DIR"; return 1; }

    # Check file ubuntu-base
    if [[ ! -f "$ubuntu_base_name" ]]; then
        echo "File $ubuntu_base_name does not exist. Please download it first."
        return 1
    fi

    # Create target folder
    if [[ ! -d "$target_dir" ]]; then
        echo "Directory $target_dir does not exist. Creating it..."
        mkdir "$target_dir"
        if [[ $? -ne 0 ]]; then
            echo "Failed to create directory $target_dir."
            return 1
        fi
    else
        echo "Directory $target_dir already exists. Skipping creation."
    fi

    # Tar file into target folder
    echo "Extracting $ubuntu_base_name to $target_dir..."
    tar -xf "$ubuntu_base_name" -C "$target_dir"
    if [[ $? -ne 0 ]]; then
        echo "Failed to extract $ubuntu_base_name."
        return 1
    fi

    echo "tar_ubuntu_base completed successfully."
    return 0
}

#######################################
# Main function ubuntu_base_prepare run 3 steps:
# 1. Install qemu-user-static to run arm64 on x86_64.
# 2. Download ubuntu 22.04-base file from cdimage.ubuntu.com
# 3. Extract file ubuntu 22.04-base.
#
# Globals:
#   None
# Arguments:
#   None
#######################################
function ubuntu_base_prepare() {
    # Download ubuntu 22.04-base file from cdimage.ubuntu.com
    echo "Starting download_ubuntu_base..."
    download_ubuntu_base
    if [[ $? -eq 1 ]]; then
        echo "download_ubuntu_base failed."
        exit 1
    fi
    echo "download_ubuntu_base completed successfully."

    # Extract file ubuntu 22.04-base.
    echo "Starting tar_ubuntu_base..."
    tar_ubuntu_base
    if [[ $? -eq 1 ]]; then
        echo "tar_ubuntu_base failed."
        exit 1
    fi
    echo "tar_ubuntu_base completed successfully."
}
