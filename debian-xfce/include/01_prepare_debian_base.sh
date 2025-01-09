#!/bin/bash
# --------------------------------------------------------------------------#
# Description:
# This script prepares the basic Ubuntu OS binaries required for the project.
# --------------------------------------------------------------------------#

# Define global variable:
WORK_DIR=$(pwd)

# 1. Install qemu-user-static
function install_qemu() {
    echo "Config binfmt..."
    # Mount binfmt to enable this feature
    if ! mountpoint -q /proc/sys/fs/binfmt_misc; then
        echo "Mounting binfmt_misc..."
        if sudo mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc; then
            echo "binfmt_misc mounted successfully."
        else
            echo "Failed to mount binfmt_misc."
            return 1
        fi
        echo "binfmt_misc mounted successfully."
    else
        echo "binfmt_misc is already mounted."
    fi

    # Config interpreter for qemu
    local magic='\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00'
    local mask='\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'
    local arch='aarch64'
    local interpreter="/usr/bin/qemu-$arch-static"
    # Check interpreter file's existance
    if [[ ! -f "$interpreter" ]]; then
        echo "Interpreter file $interpreter does not exist. Registering QEMU interpreter..."
        echo ":qemu-$arch:M::$magic:$mask:$interpreter:" | sudo tee /proc/sys/fs/binfmt_misc/register
        echo "QEMU interpreter registered successfully."
    else
        echo "Interpreter file $interpreter already exists."
    fi

    echo "Installing qemu-user-static..."

    # Update
    sudo apt-get update
    if [[ $? -ne 0 ]]; then
        echo "Failed to update package list."
        return 1
    fi

    # Install qemu-user-static
    sudo apt-get install -y qemu-user-static zstd
    if [[ $? -ne 0 ]]; then
        echo "Failed to install qemu-user-static."
        return 1
    fi

    echo "install_qemu completed successfully."
    return 0
}

# 2. Download debian base
function download_debian_base() {
    echo "Downloading debian base..."
    local target_dir="Debian_bookworm"
    # Change dir WORK_DIR
    echo "Current working directory is: $WORK_DIR"
    cd "$WORK_DIR" || { echo "Failed to change to WORK_DIR"; return 1; }

    # Install wget
    sudo apt-get install -y wget debootstrap
    if [[ $? -ne 0 ]]; then
        echo "Failed to install wget."
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

    # Create debian base
    debootstrap --arch=arm64 --foreign bookworm $target_dir https://debian.osuosl.org/debian/
    if [[ $? -ne 0 ]]; then
        echo "Failed to create debian base."
        return 1
    fi

    echo "download_debian_base completed successfully."
    return 0
}

# --------------------------------------------------------------------------#
# function debian_base_prepare use to prepare basic binaries of ubuntu os.
# function debian_base_prepare contain 3 step:
# 1. Install qemu-user-static
# 2. Download ubuntu 22.04-base
# 3. Tar file ubuntu base
# --------------------------------------------------------------------------#

# Main function debian_base_prepare
function debian_base_prepare() {
    echo "1. Starting install_qemu..."
    install_qemu
    if [[ $? -eq 1 ]]; then
        echo "install_qemu failed."
        exit 1
    fi
    echo "install_qemu completed successfully."

    echo "2. Starting download_debian_base..."
    download_debian_base
    if [[ $? -eq 1 ]]; then
        echo "download_debian_base failed."
        exit 1
    fi
    echo "download_debian_base completed successfully."

}
