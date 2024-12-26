#!/bin/bash
# --------------------------------------------------------------------------#
# Description:
# This script prepares the basic Ubuntu OS binaries required for the project.
# --------------------------------------------------------------------------#

# Define global variable:
WORK_DIR=$(pwd)

# 1. Install qemu-user-static
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

# 2. Download ubuntu 22.04-base
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

    # Check if UBUNTU_BASE_FILE_NAME is defined, if not, assign the default value 'ubuntu-base-22.04-base-arm64.tar.gz'
    : "${UBUNTU_BASE_FILE_NAME:=ubuntu-base-22.04-base-arm64.tar.gz}"

    # Check if UBUNTU_BASE_LINK is defined, if not, assign the default URL
    : "${UBUNTU_BASE_LINK:=https://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/$UBUNTU_BASE_FILE_NAME}"

    # Assign the value of UBUNTU_BASE_FILE_NAME to local variable 'file_name'
    local file_name="$UBUNTU_BASE_FILE_NAME"

    # Assign the value of UBUNTU_BASE_LINK to local variable 'url'
    local url="$UBUNTU_BASE_LINK"

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

# 3. Tar file ubuntu base
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

# --------------------------------------------------------------------------#
# function ubuntu_base_prepare use to prepare basic binaries of ubuntu os.
# function ubuntu_base_prepare contain 3 step:
# 1. Install qemu-user-static
# 2. Download ubuntu 22.04-base
# 3. Tar file ubuntu base
# --------------------------------------------------------------------------#

# Main function ubuntu_base_prepare
function ubuntu_base_prepare() {
    echo "1. Starting install_qemu..."
    install_qemu
    if [[ $? -eq 1 ]]; then
        echo "install_qemu failed."
        exit 1
    fi
    echo "install_qemu completed successfully."

    echo "2. Starting download_ubuntu_base..."
    download_ubuntu_base
    if [[ $? -eq 1 ]]; then
        echo "download_ubuntu_base failed."
        exit 1
    fi
    echo "download_ubuntu_base completed successfully."

    echo "3. Starting tar_ubuntu_base..."
    tar_ubuntu_base
    if [[ $? -eq 1 ]]; then
        echo "tar_ubuntu_base failed."
        exit 1
    fi
    echo "tar_ubuntu_base completed successfully."
}
