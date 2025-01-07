#!/bin/bash
# --------------------------------------------------------------------------------#
# Main function 
# --------------------------------------------------------------------------------#

# include
source include/01_prepare_ubuntu_base.sh
source include/02_prepare_rootfs_qt.sh
source include/03_prepare_conf.sh
source include/04_mount.sh
source include/05_create_swap.sh

# main function
function main(){
    # prepare ubuntu base
    ubuntu_base_prepare
    if [[ $? -eq 1 ]]; then
        echo "ubuntu_base_prepare failed."
        exit 1
    fi

    # prepare rootfs qt
    rootfs_qt
    if [[ $? -eq 1 ]]; then
        echo "rootfs_qt failed."
        exit 1
    fi

    # prepare conf
    set_config
    if [[ $? -eq 1 ]]; then
        echo "set_config failed."
        exit 1
    fi

    # mount chroot to install basic package
    chroot_run_1_script "apt_install_base.sh"
    if [[ $? -eq 1 ]]; then
        echo "set_config failed."
        exit 1
    fi
    
    # install lxde desktop
    chroot_run_1_script "apt_lxde_desktop.sh"
    if [[ $? -eq 1 ]]; then
        echo "apt_lxde_desktop failed."
        exit 1
    fi

    # create rzpi user - normal user
    chroot_run_1_script "create_rzpi_user.sh"
    if [[ $? -eq 1 ]]; then
        echo "create_rzpi_user failed."
        exit 1
    fi

    # set root password
    chroot_run_1_script "set_root_password.sh"
    if [[ $? -eq 1 ]]; then
        echo "set_root_password failed."
        exit 1
    fi

    # set permissions
    chroot_run_1_script "setup-set-permissions.sh"
    if [[ $? -eq 1 ]]; then
        echo "setup-set-permissions.sh failed."
        exit 1
    fi

    # install wifi and ble package
    chroot_run_1_script "apt_wifi_ble.sh"
    if [[ $? -eq 1 ]]; then
        echo "apt_wifi_ble failed."
        exit 1
    fi

    # install audio and video package
    chroot_run_1_script "apt_audio_video.sh"
    if [[ $? -eq 1 ]]; then
        echo "apt_audio_video failed."
        exit 1
    fi

    # Setup config for swap file
    chroot_run_1_script "set_swap_enable.sh"
    if [[ $? -eq 1 ]]; then
        echo "set_swap_enable failed."
        exit 1
    fi

    # Create swap file
    create_swap
    if [[ $? -eq 1 ]]; then
        echo "create_swap failed."
        exit 1
    fi

    # package rootfs to tar file
    package_rootfs
    if [[ $? -eq 1 ]]; then
        echo "package_rootfs failed."
        exit 1
    fi

}

# call main
main
