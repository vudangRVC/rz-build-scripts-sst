#!/bin/bash
# --------------------------------------------------------------------------#
# Description:
# The script defines functions to handle mounting behavior, running pre-defined
# scripts, package target rootfs to tar.bz2.
# --------------------------------------------------------------------------#

# Define global path
WORK_DIR=$(pwd)
ROOTFS="./Debian_bookworm"
SCRIPT_PATH="./script"

# 1. mount the ubuntu filesystem using ch-mount.sh.
function mount_chroot() {
    echo "Mounting chroot environment..."

    # Change dir WORK_DIR
    echo "Current working directory is: $WORK_DIR"
    cd "$WORK_DIR" || { echo "Failed to change to WORK_DIR"; return 1; }

    # Mount folder
    sudo mount -t proc /proc "$ROOTFS"/proc || { echo "Failed to mount /proc"; return 1; }
    sudo mount -t sysfs /sys "$ROOTFS"/sys || { echo "Failed to mount /sys"; return 1; }
    sudo mount -o bind /dev "$ROOTFS"/dev || { echo "Failed to bind mount /dev"; return 1; }
    sudo mount -o bind /dev/pts "$ROOTFS"/dev/pts || { echo "Failed to bind mount /dev/pts"; return 1; }

    echo "Mount chroot completed successfully."
        
    return 0
}

# 2. umount 
function umount_chroot() {
    echo "Unmounting chroot environment..."

    # Change dir WORK_DIR
    echo "Current working directory is: $WORK_DIR"
    cd "$WORK_DIR" || { echo "Failed to change to WORK_DIR"; return 1; }

    # Unmount and check error
    sudo umount "$ROOTFS"/proc || { echo "Failed to unmount /rootfs/proc"; return 1; }
    sudo umount "$ROOTFS"/sys || { echo "Failed to unmount /rootfs/sys"; return 1; }
    sudo umount "$ROOTFS"/dev/pts || { echo "Failed to unmount /rootfs/dev/pts"; return 1; }
    sudo umount "$ROOTFS"/dev || { echo "Failed to unmount /rootfs/dev"; return 1; }

    echo "umount_chroot completed successfully."
    return 0
}

# 3. run many script
chroot_run_list_script() {
    local script_dir="/script" 
    local scripts=("$@")    

    # Create command file script
    local script_commands=""
    for script in "${scripts[@]}"; do
        script_commands+="$script_dir/$script; "
    done

    # Chroot and excute script
    sudo chroot "$ROOTFS" /bin/bash -c "
        chmod 777 /tmp
        cd /
        $script_commands
    " || { echo "Failed to execute scripts in chroot"; return 1; }

    return 0
}


# Function check_and_copy_script_folder
copy_script() {
    local input_folder="./script"
    local destination="$ROOTFS/script"

    # Check input script
    if [[ ! -e $input_folder/$1 ]]; then
        echo "File $input_folder/$1 not found"
        return 1
    fi

    chmod a+x $input_folder/$1

    # Create target folder
    if [[ ! -d "$destination" ]]; then
        echo "Directory $destination does not exist. Creating it..."
        mkdir "$destination"
        if [[ $? -ne 0 ]]; then
            echo "Failed to create directory $destination."
            return 1
        fi
    else
        echo "Directory $destination already exists. Skipping creation."
    fi

    cp "$input_folder/$1" "$destination" || { echo "Failed to copy $input_folder/$1"; return 1; }
    return 0

}

# 4. run only 1 script
chroot_run_1_script() {
    trap 'echo "Caught Ctrl+C, running umount_chroot..."; umount_chroot; exit 1' SIGINT
    copy_script $1
    if [[ $? -eq 1 ]]; then
        echo "copy_script $1 failed."
        exit 1
    fi

    mount_chroot
    local script_dir="/script" 
    local scripts=("$@")    

    # Create command file script
    local script_commands=""
    script_commands+="$script_dir/$1; "

    # Chroot and excute script
    sudo chroot "$ROOTFS" /bin/bash -c "
        chmod 777 /tmp
        chmod 777 $script_dir/$1
        cd /
        $script_commands
    " || { echo "Failed to execute scripts in chroot"; umount_chroot; return 1; }
    umount_chroot

    return 0
}

# Remove /script
chroot_rm_script() {
    trap 'echo "Caught Ctrl+C, running umount_chroot..."; umount_chroot; exit 1' SIGINT
    mount_chroot
    local script_dir="/script" 

    # Create target folder
    if [[ -d "$script_dir" ]]; then
        echo "Directory $script_dir does exist. Deleting it..."
        rm -rf "$script_dir"
        if [[ $? -ne 0 ]]; then
            echo "Failed to rm directory $script_dir."
            return 1
        fi
    else
        echo "Directory $destination does not exists. Skipping..."
    fi

    # Chroot and excute script
    sudo chroot "$ROOTFS" /bin/bash -c "
        chmod 777 /tmp
        chmod 777 $script_dir/$1
        cd /
        $script_commands
    " || { echo "Failed to execute scripts in chroot"; umount_chroot; return 1; }
    umount_chroot

    return 0
}

# Package file rootfs:
function package_rootfs() {
    echo "Removing /script ..."
    chroot_rm_script
    echo "Packaging rootfs..."

    # Change dir WORK_DIR
    echo "Current working directory is: $WORK_DIR"
    cd "$WORK_DIR" || { echo "Failed to change to WORK_DIR"; return 1; }

    # Check folder rootfs exist
    if [[ ! -d "rootfs" ]]; then
        echo "Directory rootfs not found"
        return 1
    fi
    OUTPUT_ROOTFS="${OUTPUT_ROOTFS:=rootfs}"
    # Check and remove old rootfs file if exist
    if [[ -e "$OUTPUT_ROOTFS.tar.bz2" ]]; then
        rm "$OUTPUT_ROOTFS".tar.bz2
    fi

    # Create file tar.zst from folder rootfs and check error
    sudo tar -cvjf "$OUTPUT_ROOTFS".tar.bz2 -C rootfs . || { echo "Failed to package rootfs into $OUTPUT_ROOTFS.tar.bz2"; return 1; }

    echo "package_rootfs completed successfully."
    return 0
}
