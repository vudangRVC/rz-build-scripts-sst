# config.sh
# Configuration file for the script

# Define boot partition size in MB (should be larger than 100MB)
BOOT_SIZE_MB=200

# Define rootfs partition extra space in MB
ROOTFS_SPACE=5000

# Define ubuntu base file name and link that will be downloaded
UBUNTU_BASE_FILE_NAME="ubuntu-base-22.04-base-arm64.tar.gz"
UBUNTU_BASE_LINK="https://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/$UBUNTU_BASE_FILE_NAME"

# Define output wic file name
OUTPUT_WIC="ubuntu-image-qt-rzpi.wic"

# Time zone data
TIME_ZONE_AREA='tzdata tzdata/Areas select Asia'
TIME_ZONE_CITY='tzdata tzdata/Zones/Asia select Ho_Chi_Minh'
