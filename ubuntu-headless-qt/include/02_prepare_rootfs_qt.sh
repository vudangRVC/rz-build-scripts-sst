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
    cp -r $src_boot/* "$target_dir" || { echo "Failed to copy 'boot' directory"; return 1; }
    echo "Copied contain in '$src_boot' directory to '$target_dir'."

    echo "copy completed successfully."
    return 0
}

# Copy kernel module
function copy_kernel_modules() {
    echo "Copying copy_kernel_modules folder..."
    # Change dir WORK_DIR
    echo "Current working directory is: $WORK_DIR"
    cd "$WORK_DIR" || { echo "Failed to change to WORK_DIR"; return 1; }
    local src_dir="rootfs_qt/lib/modules/"
    local target_dir="rootfs/lib"
    # Check folder src
    if [[ ! -d "$src_dir" ]]; then
        echo "Source directory '$src_dir' does not exist!"
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
    # Copy folder
    cp -r $src_dir "$target_dir" || { echo "Failed to copy '$src_dir' directory"; return 1; }
    echo "Copied folder '$src_dir' directory to '$target_dir'."
    echo "Copy completed successfully."
    return 0
}

# 3. Copy QT folder
function copy_qt() {
    echo "Copying qt files..."

    # Change dir WORK_DIR
    echo "Current working directory is: $WORK_DIR"
    cd "$WORK_DIR" || { echo "Failed to change to WORK_DIR"; return 1; }

    local src_qt="rootfs_qt/usr"
    local target_dir="rootfs/usr"

    # Copy folder boot
    cp -rd "$src_qt/share/qt5" "$target_dir/share" || { echo "Failed to copy 'qt lib' directory"; return 1; }
    cp -rd "$src_qt/lib64/qt5" "$target_dir/lib/aarch64-linux-gnu/" || { echo "Failed to copy 'aarch64-linux-gnu' directory"; return 1; }
    cp -rd "$src_qt/lib64/libQt"* "$target_dir/lib/aarch64-linux-gnu/" || { echo "Failed to copy 'aarch64-linux-gnu' directory"; return 1; }
    mkdir -p "$target_dir/lib/aarch64-linux-gnu/pkgconfig/" || { echo "Failed to mkdir 'lib/aarch64-linux-gnu/pkgconfig' directory"; return 1; }
    cp -rd "$src_qt/lib64/pkgconfig/Qt"* "$target_dir/lib/aarch64-linux-gnu/pkgconfig/" || { echo "Failed to copy 'pkgconfig' directory"; return 1; }
    echo "Copied contents."

    echo "copy completed successfully."
    return 0
}

# 4. Copy wifi firmware folder
function copy_wifi_firmware() {
    echo "Copying wifi_firmware files..."

    # Change dir WORK_DIR
    echo "Current working directory is: $WORK_DIR"
    cd "$WORK_DIR" || { echo "Failed to change to WORK_DIR"; return 1; }

    local src_qt="rootfs_qt/lib/firmware"
    local target_dir="rootfs/lib"

    # Copy folder
    mkdir -p "$target_dir/firmware" || { echo "Failed to mkdir '/lib/firmware' directory"; return 1; }
    cp -rd "$src_qt/"* "$target_dir/firmware/" || { echo "Failed to copy 'firmware' directory"; return 1; }
    echo "Copied contents."

    echo "copy completed successfully."
    return 0
}

# Function main
function rootfs_qt() {
    echo "4. Starting tar_core_image_qt..."
    tar_core_image_qt
    if [[ $? -eq 1 ]]; then
        echo "tar_core_image_qt failed."
        return 1
    fi
    echo "tar_core_image_qt completed successfully."

    echo "5. Starting copy_boot_folder and copy_qt, copy_wifi_firmware..."
    copy_boot_folder
    if [[ $? -eq 1 ]]; then
        echo "copy_boot_folder failed."
        return 1
    fi
    copy_qt
    if [[ $? -eq 1 ]]; then
        echo "copy_qt failed."
        return 1
    fi
    copy_wifi_firmware
    if [[ $? -eq 1 ]]; then
        echo "copy_wifi_firmware failed."
        return 1
    fi
    echo "copy_boot_folder and copy_qt, copy_wifi_firmware completed successfully."

    echo "6. Starting copy_kernel_modules..."
    copy_kernel_modules
    if [[ $? -eq 1 ]]; then
        echo "copy_kernel_modules failed."
        return 1
    fi
    echo "copy_kernel_modules completed successfully."
    return 0
}
