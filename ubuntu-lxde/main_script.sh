#!/bin/bash
# --------------------------------------------------------------------------------#
# Main function 
# --------------------------------------------------------------------------------#

# include
source include/01_prepare_ubuntu_base.sh
source include/02_prepare_rootfs_qt.sh


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
}

# call main
main
