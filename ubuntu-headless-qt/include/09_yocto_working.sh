#!/bin/bash
# --------------------------------------------------------------------------#
# This script provides functions that help main script handle yocto part
# --------------------------------------------------------------------------#

# This function help main script can build yocto
function build_yocto() {
    # Get source yocto
    su -c "bash -c 'source include/08_yocto_source.sh; mkdir yocto_rzsbc_board ; cd yocto_rzsbc_board ; get_bsp'" $MAIN_USER

    # rename to meta-renesas
    if [ -d "yocto_rzsbc_board/meta-renesas-sst" ]; then
        echo "Change meta-renesas-sst to meta-renesas"
        mv "yocto_rzsbc_board/meta-renesas-sst" "yocto_rzsbc_board/meta-renesas"
    fi

    # Check new distro availability
    FILE="yocto_rzsbc_board/meta-renesas/meta-rz-common/recipes-core/images/renesas-ubuntu.bb"
    if [ -f "$FILE" ]; then
        echo "Found custom distro image for ubuntu core"
    else
        # Build yocto
        echo "Custom image not found"
        return 1
    fi

    # Initialize a variable to store the result
    result=""

    # Loop until we find the output file
    while [ -z "$result" ]; do
        # Run bitbake
        su -c "bash -c 'source include/08_yocto_source.sh; cd yocto_rzsbc_board ; setup_conf; \
        MACHINE=rzpi DISTRO=ubuntu-tiny bitbake renesas-ubuntu'" $MAIN_USER

        # Check the output
        result=$(find yocto_rzsbc_board/build/tmp/deploy/ -name '*.tar.bz2' -exec cp {} ./core-image-qt-rzpi.tar.bz2 \; && echo "File copied successfully.")

        # Exit if yocto does not build successfully
        if [ -z "$result" ]; then
            echo "[Yocto]: No output files found. Retrying..."
        else
            echo "Yocto output have been built."
        fi
    done
}

# This function help main script bring wic file to yocto output's directory
function move_wic_to_yocto_output(){
    # Check output folder availability
    DIR="yocto_rzsbc_board/build/tmp/deploy/images/rzpi/target/images"
    if [ -d "$DIR" ]; then
        echo "Found output yocto folder"
        mv "$OUTPUT_WIC"* $DIR
    fi
}