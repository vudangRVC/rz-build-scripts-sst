#!/bin/bash
# --------------------------------------------------------------------------#
# function rootfs_qt use to copy binaries of rootfs_qt to ubuntu os.
# function rootfs_qt contain 2 steps:
# 1. Tar file core_image_qt
# 2. Copy boot folder
# --------------------------------------------------------------------------#

# Define global variable:
WORK_DIR=$(pwd)

# 1. Tar file core_image_qt
function tar_core_image_qt() {
    echo "Extracting core-image-qt..."

    local file_name="core-image-qt-rzpi.tar.bz2"
    local target_dir="rootfs_qt"
    local check_file="rootfs_qt/home"

    # Change dir WORK_DIR
    echo "Current working directory is: $WORK_DIR"
    cd "$WORK_DIR" || { echo "Failed to change to WORK_DIR"; return 1; }

    # Check file core_image_qt
    if [[ ! -f "$file_name" ]]; then
        echo "File $file_name does not exist. Please download it first."
        return 1
    fi

    # Check if the file has already been extracted
    if [[ -e "$check_file" ]]; then
        echo "File has already been extracted. Skipping extraction."
        return 0
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

    ls $target_dir
    echo "tar_core_image_qt completed successfully."
    return 0
}

# 2. Copy boot folder
function copy_boot_folder() {
    echo "Copying kernel files..."

    # Change dir WORK_DIR
    echo "Current working directory is: $WORK_DIR"
    cd "$WORK_DIR" || { echo "Failed to change to WORK_DIR"; return 1; }

    local src_boot="rootfs_qt/boot"
    local target_dir="rootfs/boot"

    # Check folder src
    if [[ ! -d "$src_boot" ]]; then
        echo "Source directory '$src_boot' does not exist!"
        return 1
    fi

    # Create target folder
    if [[ ! -d "$target_dir" ]]; then
        echo "Directory $target_dir does not exist. Creating it..."
        mkdir -p "$target_dir"
        if [[ $? -ne 0 ]]; then
            echo "Failed to create directory $target_dir."
            return 1
        fi
    else
        echo "Directory $target_dir already exists. Skipping creation."
    fi

    # Copy folder boot
    cp -r $src_boot/* "$target_dir" || { echo "Failed to copy 'overlays' directory"; return 1; }
    echo "Copied contain in '$src_boot' directory to '$target_dir'."

    echo "copy completed successfully."
    return 0
}

# Function main
function rootfs_qt() {
    echo "4. Starting tar_core_image_qt..."
    tar_core_image_qt
    if [[ $? -eq 1 ]]; then
        echo "tar_core_image_qt failed."
        exit 1
    fi
    echo "tar_core_image_qt completed successfully."

    echo "5. Starting copy_boot_folder..."
    copy_boot_folder
    if [[ $? -eq 1 ]]; then
        echo "copy_boot_folder failed."
        exit 1
    fi
    echo "copy_boot_folder completed successfully."
}
