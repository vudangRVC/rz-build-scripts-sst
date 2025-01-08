#!/bin/bash
##############################################################################
# This script sets up the Ubuntu OS configuration by performing the following:
# 1. Copy qemu-aarch64-static
# 2. Copy resolv.conf
# 3. Set up log file for syslog
# 4. Set LightDM configuration
# 5. Configure network interfaces
# 6. Copy camera configuration
##############################################################################

# Define global variables
WORK_DIR=$(pwd)
ROOTFS="./rootfs"
BIN_PATH="$ROOTFS/usr/bin"
ETC_PATH="$ROOTFS/etc"
LOG_PATH="$ROOTFS/var/log"
BOOT_PATH="$ROOTFS/boot"

#######################################
# Function copy_qemu use to copy qemu-aarch64-static to ubuntu os.
# Globals:
#   WORK_DIR
# Arguments:
#   None
#######################################
function copy_qemu() {
    echo "Copying qemu-aarch64-static..."

    # Change dir WORK_DIR
    echo "Current working directory is: $WORK_DIR"
    cd "$WORK_DIR" || { echo "Failed to change to WORK_DIR"; return 1; }

    # Check BIN_PATH
    if [[ -z "$BIN_PATH" ]]; then
        echo "BIN_PATH is not set."
        return 1
    fi

    # Create folder BIN_PATH
    mkdir -p "$BIN_PATH" || { echo "Failed to create $BIN_PATH"; return 1; }

    # Copy qemu-aarch64-static
    cp /usr/bin/qemu-aarch64-static "$BIN_PATH/" || { echo "Failed to copy qemu-aarch64-static"; return 1; }
    echo "Copied qemu-aarch64-static successfully."
    return 0
}


#######################################
# Function copy_resolv_conf use to copy resolv.conf to ubuntu os.
# Globals:
#   WORK_DIR
# Arguments:
#   None
#######################################
function copy_resolv_conf() {
    echo "Copying resolv.conf..."

    # Change dir WORK_DIR
    echo "Current working directory is: $WORK_DIR"
    cd "$WORK_DIR" || { echo "Failed to change to WORK_DIR"; return 1; }

    # Check ETC_PATH
    if [[ -z "$ETC_PATH" ]]; then
        echo "ETC_PATH is not set."
        return 1
    fi

    # Create folder ETC_PATH
    mkdir -p "$ETC_PATH" || { echo "Failed to create $ETC_PATH"; return 1; }

    # Copy resolv.conf
    cp /etc/resolv.conf "$ETC_PATH/resolv.conf" || { echo "Failed to copy resolv.conf"; return 1; }
    echo "Copied resolv.conf successfully."
    return 0
}

#######################################
# Function setup_log_file use to set up log file for syslog.
# Globals:
#   WORK_DIR
# Arguments:
#   None
#######################################
function setup_log_file() {
    echo "Setting up log file..."

    # Change dir WORK_DIR
    echo "Current working directory is: $WORK_DIR"
    cd "$WORK_DIR" || { echo "Failed to change to WORK_DIR"; return 1; }

    # Check LOG_PATH
    if [[ -z "$LOG_PATH" ]]; then
        echo "LOG_PATH is not set."
        return 1
    fi

    # Create folder LOG_PATH
    mkdir -p "$LOG_PATH" || { echo "Failed to create $LOG_PATH"; return 1; }

    # Set up log file
    LOG_FILE="$LOG_PATH/rsyslog"
    touch "$LOG_FILE" || { echo "Failed to create log file"; return 1; }

    # Change log file permissions
    chmod 666 "$LOG_FILE" || { echo "Failed to change log file permissions"; return 1; }

    echo "Log file set up successfully."
    return 0
}

#######################################
# Function set_lightdm_config use to set LightDM configuration.
# Globals:
#   WORK_DIR
# Arguments:
#   None
#######################################
function set_lightdm_config() {
    echo "Setting LightDM configuration..."

    # Change dir WORK_DIR
    echo "Current working directory is: $WORK_DIR"
    cd "$WORK_DIR" || { echo "Failed to change to WORK_DIR"; return 1; }

    # Check ETC_PATH
    if [[ -z "$ETC_PATH" ]]; then
        echo "ETC_PATH is not set."
        return 1
    fi

    # Set up LightDM configuration
    LIGHTDM_CONF="$ETC_PATH/lightdm/lightdm.conf"

    # Check and create folder
    mkdir -p "$(dirname "$LIGHTDM_CONF")" || { echo "Failed to create $(dirname "$LIGHTDM_CONF")"; return 1; }

    # Write to LightDM configuration
    echo -e "[SeatDefaults]\nuser-session=LXDE" > "$LIGHTDM_CONF" || { echo "Failed to write to $LIGHTDM_CONF"; return 1; }

    echo "LightDM configuration set up successfully."
    return 0
}

#######################################
# Function set_network_config use to configure network interfaces.
# Globals:
#   WORK_DIR
# Arguments:
#   None
#######################################
function set_network_config() {
    echo "Configuring network interfaces..."

    # Change dir WORK_DIR
    echo "Current working directory is: $WORK_DIR"
    cd "$WORK_DIR" || { echo "Failed to change to WORK_DIR"; return 1; }

    # Check ETC_PATH
    if [[ -z "$ETC_PATH" ]]; then
        echo "ETC_PATH is not set."
        return 1
    fi

    # Define the path for network configuration
    NETWORK_CONF="$ETC_PATH/network/interfaces"
    
    # Check and create folder
    mkdir -p "$(dirname "$NETWORK_CONF")" || { echo "Failed to create $(dirname "$NETWORK_CONF")"; return 1; }

    # Check exist file network config
    NETWORK_CONFIG_FILE="./config/network_interfaces.conf"
    if [[ ! -f "$NETWORK_CONFIG_FILE" ]]; then
        echo "Configuration file $NETWORK_CONFIG_FILE not found"
        return 1
    fi

    # Copy network config
    sudo cp "$NETWORK_CONFIG_FILE" "$NETWORK_CONF" || { echo "Failed to copy $NETWORK_CONFIG_FILE to $NETWORK_CONF"; return 1; }

    echo "Network interfaces configured successfully."
    return 0
}

#######################################
# Function copy_camera_config use to set camera configure.
# Globals:
#   WORK_DIR
# Arguments:
#   None
#######################################
function copy_camera_config() {
    echo "Copying camera config..."

    # Change dir WORK_DIR
    echo "Current working directory is: $WORK_DIR"
    cd "$WORK_DIR" || { echo "Failed to change to WORK_DIR"; return 1; }

    # Check script v4l2-init.sh exist
    local script_dir="$WORK_DIR/config/v4l2-init.sh"
    if [[ ! -e "$script_dir" ]]; then
        echo "v4l2-init.sh is not exist."
        return 1
    fi

    # Create target folder
    local target_dir="$WORK_DIR/rootfs/etc/profile.d"
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

    # Copy script to target folder
    sudo cp "$script_dir" "$target_dir" || { echo "Failed to copy $script_dir to $target_dir"; return 1; }

    echo "copy $script_dir to $target_dir successfully."
    return 0
}

#######################################
# Function set_config use to copy config file to ubuntu os.
# 1. Copy qemu-aarch64-static
# 2. Copy resolv.conf
# 3. Set up log file for syslog
# 4. Set LightDM configuration
# 5. Configure network interfaces
#
# Globals:
#   WORK_DIR
# Arguments:
#   None
#######################################
function set_config() {
    echo "Setting configuration..."

    # Change dir WORK_DIR
    echo "Current working directory is: $WORK_DIR"
    cd "$WORK_DIR" || { echo "Failed to change to WORK_DIR"; return 1; }

    # Copy qemu-aarch64-static
    copy_qemu
    if [[ $? -eq 1 ]]; then
        echo "Failed to copy qemu-aarch64-static. Exiting."
        return 1
    fi

    # Copy resolv.conf
    copy_resolv_conf
    if [[ $? -eq 1 ]]; then
        echo "Failed to copy resolv.conf. Exiting."
        return 1
    fi

    # Set up log file
    setup_log_file
    if [[ $? -eq 1 ]]; then
        echo "Failed to set up log file. Exiting."
        return 1
    fi

    # Set LightDM configuration
    set_lightdm_config
    if [[ $? -eq 1 ]]; then
        echo "Failed to set LightDM configuration. Exiting."
        return 1
    fi

    # Configure network interfaces
    set_network_config
    if [[ $? -eq 1 ]]; then
        echo "Failed to configure network interfaces. Exiting."
        return 1
    fi

    # Copy camera config
    copy_camera_config
    if [[ $? -eq 1 ]]; then
        echo "Failed to configure config_camera. Exiting."
        return 1
    fi

    echo "Configuration completed successfully."
    return 0
}

