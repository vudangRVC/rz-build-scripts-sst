#!/bin/bash

file="core-image-qt-rzpi.tar.bz2"

function prepare_env() {

    # Check env
    if [ ! -f "$file" ]; then
        echo "File '$file' not found. Please copy it over."
        return 1
    fi

    if [ -d "rootfs" ]; then
        rm -rf "rootfs"
        echo "Directory 'rootfs' removed."
    fi

    if [ -d "rootfs_qt" ]; then
        rm -rf "rootfs_qt"
        echo "Directory 'rootfs_qt' removed."
    fi
}
