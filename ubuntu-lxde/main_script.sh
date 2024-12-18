#!/bin/bash
# --------------------------------------------------------------------------------#
# Main function 
# --------------------------------------------------------------------------------#

# include
source include/01_prepare_ubuntu_base.sh
source include/02_prepare_rootfs_qt.sh
source include/03_prepare_conf.sh
source include/04_mount.sh


# main function
function main(){
    ubuntu_base_prepare
    if [[ $? -eq 1 ]]; then
        echo "ubuntu_base_prepare failed."
        exit 1
    fi

    rootfs_qt
    if [[ $? -eq 1 ]]; then
        echo "rootfs_qt failed."
        exit 1
    fi

    set_config
    if [[ $? -eq 1 ]]; then
        echo "set_config failed."
        exit 1
    fi

    chroot_run_1_script "apt_install_base.sh"
    if [[ $? -eq 1 ]]; then
        echo "set_config failed."
        exit 1
    fi

    chroot_run_1_script "set_root_password.sh"
    if [[ $? -eq 1 ]]; then
        echo "set_root_password failed."
        exit 1
    fi
}

# call main
main
