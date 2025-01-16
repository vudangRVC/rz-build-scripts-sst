#!/bin/bash
##############################################################################
# This is main script to run all script to build ubuntu os with lxde-desktop.
##############################################################################

# Include script
source include/01_prepare_ubuntu_base.sh
source include/02_prepare_rootfs_qt.sh
source include/03_prepare_conf.sh
source include/04_mount.sh
source include/05_create_swap.sh

#######################################
# Function main use to run all script to build ubuntu os with lxde-desktop.
# It will be config ubuntu OS, install applications define in script.
# It package rootfs to tar file after run all script.
#
# Globals:
#   ROOTFS
# Arguments:
#   None
#######################################
function main(){
    # Install qemu-user-static
    install_qemu
    if [[ $? -eq 1 ]]; then
        echo "install_qemu failed."
        exit 1
    fi
    echo "install_qemu completed successfully."

    # Prepare ubuntu base
    ubuntu_base_prepare $1
    if [[ $? -eq 1 ]]; then
        echo "ubuntu_base_prepare failed."
        exit 1
    fi

    # Prepare rootfs qt
    rootfs_qt
    if [[ $? -eq 1 ]]; then
        echo "rootfs_qt failed."
        exit 1
    fi

    # Set config
    set_config
    if [[ $? -eq 1 ]]; then
        echo "set_config failed."
        exit 1
    fi

    # Mount chroot to install basic package
    chroot_run_1_script "apt_install_base.sh"
    if [[ $? -eq 1 ]]; then
        echo "apt_install_base failed."
        exit 1
    fi

    # Install lxde desktop
    chroot_run_1_script "apt_lxde_desktop.sh"
    if [[ $? -eq 1 ]]; then
        echo "apt_lxde_desktop failed."
        exit 1
    fi

    # Create rzpi user - normal user
    chroot_run_1_script "create_rzpi_user.sh"
    if [[ $? -eq 1 ]]; then
        echo "create_rzpi_user failed."
        exit 1
    fi

    # Set root password
    chroot_run_1_script "set_root_password.sh"
    if [[ $? -eq 1 ]]; then
        echo "set_root_password failed."
        exit 1
    fi

    # Set permissions
    chroot_run_1_script "setup-set-permissions.sh"
    if [[ $? -eq 1 ]]; then
        echo "setup-set-permissions.sh failed."
        exit 1
    fi

    # Install wifi and bluetooth packages
    chroot_run_1_script "apt_wifi_ble.sh"
    if [[ $? -eq 1 ]]; then
        echo "apt_wifi_ble failed."
        exit 1
    fi

    # Install audio and video packages
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
#    create_swap
#    if [[ $? -eq 1 ]]; then
#        echo "create_swap failed."
#        exit 1
#    fi

    # # Package rootfs to tar file
    # package_rootfs
    # if [[ $? -eq 1 ]]; then
    #     echo "package_rootfs failed."
    #     exit 1
    # fi

}

# Call main function
main 22.04
