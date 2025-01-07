#!/bin/bash
#!/bin/bash
# --------------------------------------------------------------------------#
# function create_swap use to create swap partition.
# --------------------------------------------------------------------------#

# Define global path
WORK_DIR=$(pwd)
ROOTFS="./rootfs"
SCRIPT_PATH="./script"

# Create a swap file
function create_swap() {
    # Change dir ROOTFS
    echo "Current working directory is: $ROOTFS"
    cd "$ROOTFS" || { echo "Failed to change to ROOTFS"; return 1; }

    # Create a 1GB swap file
    fallocate -l 1G swapfile
    if [[ $? -ne 0 ]]; then
        echo "Failed to create swap file."
        exit 1
    fi

    # Set the correct permissions
    chmod 600 swapfile
    if [[ $? -ne 0 ]]; then
        echo "Failed to set permissions on swap file."
        exit 1
    fi

    # Set up the swap area
    mkswap swapfile
    if [[ $? -ne 0 ]]; then
        echo "Failed to set up swap area."
        exit 1
    fi

    # Enable the swap file
    swapon swapfile
    if [[ $? -ne 0 ]]; then
        echo "Failed to enable swap file."
        exit 1
    fi

    return 0

    echo "Swap file created and enabled successfully."
}
