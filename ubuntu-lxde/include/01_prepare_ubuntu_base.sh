#!/bin/bash
##############################################################################
# This script to prepare basic binaries of ubuntu os.
# 1. Install qemu-user-static to run arm64 on x86_64.
# 2. Download ubuntu 22.04-base file from cdimage.ubuntu.com
# 3. Extract file ubuntu 22.04-base.
##############################################################################

# Define global variable:
WORK_DIR=$(pwd)

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
# Download ubuntu 22.04-base
# Globals:
#   WORK_DIR
# Arguments:
#   None
#######################################
function download_ubuntu_base() {
    echo "Downloading Ubuntu 22.04-base..."

    # Change dir WORK_DIR
    echo "Current working directory is: $WORK_DIR"
    cd "$WORK_DIR" || { echo "Failed to change to WORK_DIR"; return 1; }

    # Install wget
    sudo apt-get install -y wget
    if [[ $? -ne 0 ]]; then
        echo "Failed to install wget."
        return 1
    fi

    # Check and download file ubuntu-base
    local file_name="ubuntu-base-22.04-base-arm64.tar.gz"
    local url="https://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/$file_name"

    if [[ ! -e "$file_name" ]]; then
        echo "File $file_name not found. Downloading..."
        wget "$url"
        if [[ $? -ne 0 ]]; then
            echo "Failed to download $file_name from $url."
            return 1
        fi
        echo "Download completed: $file_name"
    else
        echo "File $file_name already exists. Skipping download."
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

    local file_name="ubuntu-base-22.04-base-arm64.tar.gz"
    local target_dir="rootfs"

    # Change dir WORK_DIR
    echo "Current working directory is: $WORK_DIR"
    cd "$WORK_DIR" || { echo "Failed to change to WORK_DIR"; return 1; }

    # Check file ubuntu-base
    if [[ ! -f "$file_name" ]]; then
        echo "File $file_name does not exist. Please download it first."
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
    echo "Extracting $file_name to $target_dir..."
    tar -xf "$file_name" -C "$target_dir"
    if [[ $? -ne 0 ]]; then
        echo "Failed to extract $file_name."
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
    # 1. Install qemu-user-static to run arm64 on x86_64.
    echo "1. Starting install_qemu..."
    install_qemu
    if [[ $? -eq 1 ]]; then
        echo "install_qemu failed."
        exit 1
    fi
    echo "install_qemu completed successfully."

    # 2. Download ubuntu 22.04-base file from cdimage.ubuntu.com
    echo "2. Starting download_ubuntu_base..."
    download_ubuntu_base
    if [[ $? -eq 1 ]]; then
        echo "download_ubuntu_base failed."
        exit 1
    fi
    echo "download_ubuntu_base completed successfully."

    # 3. Extract file ubuntu 22.04-base.
    echo "3. Starting tar_ubuntu_base..."
    tar_ubuntu_base
    if [[ $? -eq 1 ]]; then
        echo "tar_ubuntu_base failed."
        exit 1
    fi
    echo "tar_ubuntu_base completed successfully."
}
