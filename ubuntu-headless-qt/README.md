# Script to build ubuntu 22.04 headless with Qt library
Build scripts for rz projects

This repo holds build scripts that download, assemble and build rz projects.

A core-image-qt-rzpi.tar.bz2 file needed for build script
Put that file inside ubuntu-headless-qt folder
User can modify the target wic size and version of ubuntu base inside `config.ini`

## How to run script
First, we need to change the permisstions of `main_script.sh` to make it executable.
Then we can execute the script as follows:
```
chmod +x main_script.sh
./main_script.sh
```

## Hierarchy
```
ubuntu-headless-qt/
├── config
│   └── network_interfaces.conf
├── config.ini
├── include
│   ├── 00_prepare_env.sh
│   ├── 01_prepare_ubuntu_base.sh
│   ├── 02_prepare_rootfs_qt.sh
│   ├── 03_prepare_conf.sh
│   ├── 04_mount.sh
│   └── 05_create_wic.sh
├── main_script.sh
├── README.md
└── script
    ├── apt_install_base.sh
    └── set_root_password.sh

3 directories, 12 files
```
