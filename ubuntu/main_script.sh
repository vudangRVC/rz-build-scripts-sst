#!/bin/bash
# --------------------------------------------------------------------------------#
# Description:
# The main function orchestrates the entire process by calling a series of
# functions in sequence to prepare the Ubuntu base, configure the system,
# set up root and user passwords, and finally package the system into a WIC image.
# --------------------------------------------------------------------------------#

# include
. config.ini
source_env(){
	if [ "$UBUNTU_TYPE" = "CORE" ]; then
		. include/ubuntu_core/prepare_rootfs_qt.sh
		. include/ubuntu_core/prepare_conf.sh
		. include/ubuntu_core/mount.sh
	elif [ "$UBUNTU_TYPE" = "LXDE" ]; then
		. include/ubuntu_lxde/prepare_rootfs_qt.sh
		. include/ubuntu_lxde/prepare_conf.sh
		. include/ubuntu_lxde/mount.sh
		. include/ubuntu_lxde/create_swap.sh
	else
		echo "Invalid value passed for UBUNTU_TYPE . Set UBUNTU_TYPE to proper value (CORE / LXDE) in config.ini file."
		exit 1
	fi
}
. include/common/prepare_env.sh
. include/common/create_wic.sh
. include/common/install_gstreamer.sh
. include/common/install_weston.sh
. include/common/yocto_working.sh
. include/common/prepare_ubuntu_base.sh

# Check if this script is clone by user (not root/sudo) or not.
do_build_yocto(){
	# Skip entering yocto env if output exists
	if [ -f "$core_image_qt_name" ]; then
		echo "Skipping do_build_yocto because $core_image_qt_name is available."
		return 0
	fi

	MAIN_USER=$(sudo grep 'sudo: .*main_script.sh' /var/log/auth.log | tail -n 1 | awk '{print $6}')
	# Recheck user for yocto build
	if [ -n "$MAIN_USER" ]; then
		echo "User executed sudo ./main_script is: $MAIN_USER"
	else
		echo "It seem that you are root. Recheck..."
		MAIN_USER=$(stat -c '%U' main_script.sh)
		if [ -n "$MAIN_USER" ]; then
			echo "User executed sudo ./main_script is: $MAIN_USER"
		else
			echo "It seem that you are root. Please login and clone as a user"
			exit 1
		fi
	fi

	if [ "$MAIN_USER" = "root" ]; then
		echo "Error: Current user cannot be root, we cannot build yocto with root's privilege."
		exit 1
	fi

	######## YOCTO WORKING ########
	build_yocto
	if [ $? -eq 1 ]; then
		echo "build_yocto failed."
		exit 1
	fi
	##### END YOCTO WORKING ######
}

# main function for ubuntu core
main_ubuntu_core(){
	# Prepare the environment by checking for required files and directories
	prepare_env
	if [ $? -eq 1 ]; then
		echo "prepare_env failed."
		exit 1
	fi

	# Prepare the Ubuntu base system (install necessary binaries and setup rootfs)
	ubuntu_base_prepare
	if [ $? -eq 1 ]; then
		echo "ubuntu_base_prepare failed."
		exit 1
	fi

	# Prepare qt_rootfs_source by copying relevant binaries and folders to the Ubuntu OS
	rootfs_qt
	if [ $? -eq 1 ]; then
		echo "rootfs_qt failed."
		exit 1
	fi

	# Set configuration files
	set_config
	if [ $? -eq 1 ]; then
		echo "set_config failed."
		exit 1
	fi

	# Run the script 'apt_install_base.sh' inside chroot environment
	chroot_run_1_script "apt_install_base.sh"
	if [ $? -eq 1 ]; then
		echo "set_config failed."
		exit 1
	fi

	# Run the script 'set_root_password.sh' inside chroot environment
	chroot_run_1_script "set_root_password.sh"
	if [ $? -eq 1 ]; then
		echo "set_root_password failed."
		exit 1
	fi

	# Install gstreamer to ubuntu
	install_gstreamer "rootfs" "qt_rootfs_source"
	if [ $? -eq 1 ]; then
		echo "install_gstreamer failed."
		exit 1
	fi

	# Install weston to ubuntu
	install_weston "rootfs" "qt_rootfs_source"
	if [ $? -eq 1 ]; then
		echo "install_weston failed."
		exit 1
	fi

	# Package the root filesystem into a compressed archive (tarball)
	package_rootfs
	if [ $? -eq 1 ]; then
		echo "package_rootfs failed."
		exit 1
	fi

	# Create a WIC image from the rootfs
	create_wic
	if [ $? -eq 1 ]; then
		echo "create_wic failed."
		exit 1
	fi

	# Move WIC output to output yocto folder
	move_ubuntu_to_yocto_output
	if [ $? -eq 1 ]; then
		echo "move_ubuntu_to_yocto_output failed."
		exit 1
	fi
}

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
main_ubuntu_lxde(){
	# Prepare the environment by checking for required files and directories
	prepare_env
	if [ $? -eq 1 ]; then
		echo "prepare_env failed."
		exit 1
	fi

	# Install qemu-user-static
	install_qemu
	if [ $? -eq 1 ]; then
		echo "install_qemu failed."
		exit 1
	fi
	echo "install_qemu completed successfully."

	# Prepare ubuntu base
	ubuntu_base_prepare
	if [ $? -eq 1 ]; then
		echo "ubuntu_base_prepare failed."
		exit 1
	fi

	# Prepare rootfs qt
	rootfs_qt
	if [ $? -eq 1 ]; then
		echo "rootfs_qt failed."
		exit 1
	fi

	# Set config
	set_config
	if [ $? -eq 1 ]; then
		echo "set_config failed."
		exit 1
	fi

	# Mount chroot to install basic package
	chroot_run_1_script "apt_install_base.sh"
	if [ $? -eq 1 ]; then
		echo "apt_install_base failed."
		exit 1
	fi

	# Create rzpi user - normal user
	chroot_run_1_script "create_rzpi_user.sh"
	if [ $? -eq 1 ]; then
		echo "create_rzpi_user failed."
		exit 1
	fi

	# Set root password
	chroot_run_1_script "set_root_password.sh"
	if [ $? -eq 1 ]; then
		echo "set_root_password failed."
		exit 1
	fi

	# Install wifi and bluetooth packages
	chroot_run_1_script "apt_wifi_ble.sh"
	if [ $? -eq 1 ]; then
		echo "apt_wifi_ble failed."
		exit 1
	fi

	# Install lxde desktop
	chroot_run_1_script "apt_lxde_desktop.sh"
	if [ $? -eq 1 ]; then
		echo "apt_lxde_desktop failed."
		exit 1
	fi

	# Install blueman for bluetooth (on 20.04 and above)
	# Get the ubuntu version
	version=$(echo "$UBUNTU_BASE_FILE_NAME" | grep -oP '\d+\.\d+')
	major_version=$(echo "$version" | cut -d '.' -f 1)

	if [ "$major_version" -ge 20 ]; then
		chroot_run_1_script "apt_blueman.sh"
	fi
	if [ $? -eq 1 ]; then
		echo "apt_blueman failed."
		exit 1
	fi

	# Install audio and video packages
	chroot_run_1_script "apt_audio_video.sh"
	if [ $? -eq 1 ]; then
		echo "apt_audio_video failed."
		exit 1
	fi

	# Package rootfs to tar file
	package_rootfs
	if [ $? -eq 1 ]; then
		echo "package_rootfs failed."
		exit 1
	fi

	# Create a WIC image from the rootfs
	create_wic
	if [ $? -eq 1 ]; then
		echo "create_wic failed."
		exit 1
	fi

	# Move WIC output to output yocto folder
	move_ubuntu_to_yocto_output
	if [ $? -eq 1 ]; then
		echo "move_ubuntu_to_yocto_output failed."
		exit 1
	fi
}

# Set the default build type to Ubuntu Core
UBUNTU_TYPE="${1:-${UBUNTU_TYPE:=CORE}}"

# call main
case "$UBUNTU_TYPE" in
	CORE)
		source_env
		do_build_yocto
		main_ubuntu_core
		;;
	LXDE)
		source_env
		do_build_yocto
		main_ubuntu_lxde
		;;
	ALL)
		UBUNTU_TYPE="CORE"
		OUTPUT_ROOTFS="ubuntu-core-image-qt-rzpi"
		OUTPUT_WIC="ubuntu-core-image-qt-rzpi.wic"
		source_env
		do_build_yocto
		main_ubuntu_core

		UBUNTU_TYPE="LXDE"
		OUTPUT_ROOTFS="ubuntu-lxde-image-qt-rzpi"
		OUTPUT_WIC="ubuntu-lxde-image-qt-rzpi.wic"
		source_env
		main_ubuntu_lxde
		;;
	*)
		echo "Unknown UBUNTU_TYPE: $UBUNTU_TYPE. Please set it to CORE or another supported type in config.ini."
		;;
esac
