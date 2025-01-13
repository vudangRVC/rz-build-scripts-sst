#!/bin/bash
# --------------------------------------------------------------------------------#
# Description:
# The main function orchestrates the entire process by calling a series of
# functions in sequence to prepare the Ubuntu base, configure the system,
# set up root and user passwords, and finally package the system into a WIC image.
# --------------------------------------------------------------------------------#

# include
source config.ini
source include/00_prepare_env.sh
source include/01_prepare_ubuntu_base.sh
source include/02_prepare_rootfs_qt.sh
source include/03_prepare_conf.sh
source include/04_mount.sh
source include/05_create_wic.sh
source include/06_install_gstreamer.sh
source include/07_install_weston.sh

# main function
function main(){
    export MAIN_USER=$USER
    if [[ "$MAIN_USER" == "root" ]]; then
        echo "Error: Current user cannot be root, we cannot build yocto with root's privilege."
        exit 1
    fi

    echo "Current user is: $MAIN_USER"

    # Get sudo privileged first, but keep current user env
    sudo -E bash

    ######## YOCTO WORKING ########
    # Get source yocto for bootloader
    su -c "bash -c 'source include/08_yocto_source.sh; mkdir bootloader && cd bootloader && get_bsp'" $MAIN_USER

    # Build bootloader in yocto
    su -c "bash -c 'source source.sh; cd bootloader ;setup_conf; \
    bitbake u-boot flash-writer bootparameter-native fiptool-native firmware-pack;bitbake trusted-firmware-a'" $MAIN_USER
    ##### END YOCTO WORKING ######

    # Prepare the environment by checking for required files and directories
    prepare_env
    if [[ $? -eq 1 ]]; then
        echo "prepare_env failed."
        exit 1
    fi

    # Prepare the Ubuntu base system (install necessary binaries and setup rootfs)
    ubuntu_base_prepare
    if [[ $? -eq 1 ]]; then
        echo "ubuntu_base_prepare failed."
        exit 1
    fi

    # Prepare qt_rootfs_source by copying relevant binaries and folders to the Ubuntu OS
    rootfs_qt
    if [[ $? -eq 1 ]]; then
        echo "rootfs_qt failed."
        exit 1
    fi

    # Set configuration files
    set_config
    if [[ $? -eq 1 ]]; then
        echo "set_config failed."
        exit 1
    fi

    # Run the script 'apt_install_base.sh' inside chroot environment
    chroot_run_1_script "apt_install_base.sh"
    if [[ $? -eq 1 ]]; then
        echo "set_config failed."
        exit 1
    fi

    # Run the script 'set_root_password.sh' inside chroot environment
    chroot_run_1_script "set_root_password.sh"
    if [[ $? -eq 1 ]]; then
        echo "set_root_password failed."
        exit 1
    fi

    # Install gstreamer to ubuntu
    install_gstreamer "rootfs" "qt_rootfs_source"
    if [[ $? -eq 1 ]]; then
        echo "install_gstreamer failed."
        exit 1
    fi

    # Install weston to ubuntu
    install_weston "rootfs" "qt_rootfs_source"
    if [[ $? -eq 1 ]]; then
        echo "install_weston failed."
        exit 1
    fi

    # Package the root filesystem into a compressed archive (tarball)
    package_rootfs
    if [[ $? -eq 1 ]]; then
        echo "package_rootfs failed."
        exit 1
    fi

    # Create a WIC image from the rootfs
    create_wic
    if [[ $? -eq 1 ]]; then
        echo "create_wic failed."
        exit 1
    fi
}

# call main
main
