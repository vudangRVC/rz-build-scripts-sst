# Ubuntu Core System development on RZG2L SBC board #
This is the quick startup guide for RZG2L SBC board (hereinafter referred to as `RZG2L-SBC`) to develop on Ubuntu LXDE (with Desktop environment support).

The following sections will describe how to build this custom Ubuntu Core image and set up the development environment for the RZG2L-SBC.

## Status
This is a Custom Ubuntu Core release of the RZG2L development product for RZG2L-SBC.

This release provides the following features:

**Audacity**
- Powerful audio editing software for recording and editing sound files.

**VLC Media Player**
- Versatile media player capable of playing a wide range of audio and video formats.

**Default Web Browser**
- Lightweight browser providing essential features for internet browsing on Ubuntu LXDE.

**Wifi**
- On-board Wireless Modules enabled (supporting Wi-Fi only) for internet connectivity.

**Bluetooth**
- Generic USB Bluetooth framework supported for connecting Bluetooth devices.

**Additional Features**
- Custom Ubuntu Core build scripts for easy setup and deployment.
- RZG2L-SBC Linux BSP functionalities.
- Graphic and Codec libraries supported for various multimedia tasks.
- 40 IO expansion interfaces supported for hardware connectivity.
- On-board Audio Codec with Stereo Jack Analog Audio IO.
- MIPI DSI and MIPI CSI-2 enabled for display and camera support.
- Bootloader with U-Boot Fastboot UDP enabled for fast booting.

Known issues:

 - Only support for 48 Khz audio sampling rate family.

## Porting the Ubuntu File System
### Introduction of Ubuntu
Ubuntu-base is the minimum file system officially built by Ubuntu, which includes the Debian package manager. The size of the base package is usually only tens of megabytes, behind which there is the entire ubuntu software repository support. Ubuntu software generally has good stability. Based on Ubuntu-base, Linux software can be installed on demand, with deep customization capabilities, and it is commonly used for embedded rootfs construction.

Several common methods for building embedded file systems include busybox, yocto and buildroot. But Ubuntu offers a convenient and powerful package management system with strong community support, allowing for the installation of new software packages directly through apt-get install. This article describes how to build a complete Ubuntu system based on Ubuntu-base. Ubuntu supports many architectures such as arm, X86, powerpc, ppc, and more. This article is mainly focusing on building a complete ubuntu system based on arm as an example.

Before starting the porting, prepare a file named `core-image-qt-rzpi.tar.bz2` and place in the same level of `main_script.sh`. This file can be get in the output yocto folder at `~/build/tmp/deploy/images/rzpi/target/images/rootfs/core-image-qt-rzpi.tar.bz2`.

> :memo: **Note:** Linux Ubuntu 22.04 is recommended for the build. Prepare environment for building package and local build environment.

Then we can execute the script as follows:
```
chmod +x main_script.sh
./main_script.sh
```
Here are the packages preinstalled after running the script:

| **Category**                     | **Package(s)**                                                                    |
|----------------------------------|-----------------------------------------------------------------------------------|
| **Basic Packages**               | dialog, rsyslog, systemd, avahi-daemon, avahi-utils, udhcpc, ssh, vim, net-tools, ethtool, ifupdown, iputils-ping, htop, tree, lrzsz, gpiod, wpasupplicant, kmod, iw, usbutils, memtester, alsa-utils, ufw, sudo,           |
| **Wifi & Bluetooth Controllers** | bluez, connman, network-manager, rfkill, dbus-x11, apt-utils, libssl-dev                          |
| **Audio and Video Support**      | v4l-utils, ubuntu-restricted-extras, audacity, vlc                                |
| **Desktop Environment and Browser** | xinit, lxde, lightdm, xserver-xorg, epiphany-browser, xine-ui, onboard, chromium-browser   |


### Hierarchy
```
├── config
│   ├── network_interfaces.conf
│   └── v4l2-init.sh
├── core-image-qt-rzpi.tar.bz2                  <---- Prepared input
├── include
│   ├── 01_prepare_ubuntu_base.sh
│   ├── 02_prepare_rootfs_qt.sh
│   ├── 03_prepare_conf.sh
│   └── 04_mount.sh
├── main_script.sh                              <---- Main execution
├── README.md                                   <---- This file
└── script
    ├── apt_audio_video.sh
    ├── apt_install_base.sh
    ├── apt_lxde_desktop.sh
    ├── apt_onboard_chrominium.sh
    ├── apt_wifi_ble.sh
    ├── create_rzpi_user.sh
    ├── set_root_password.sh
    └── setup-set-permissions.sh

3 directories, 17 files
```
### Introduction of LXDE
LXDE is a lightweight and rapid desktop environment. It is designed to be user-friendly and take up few resources while keeping resource usage low.LXDE uses less memory and CPU to present as feature-rich desktop environment as possible. Unlike other desktop environments, LXDE strives to be a modular desktop environment so that each component can be used independently. This allows porting LXDE to different distributions and platforms more easily.

LXDE contains several core components that can be used in desktop environments to manage the entire system resources. The main components are listed below:

- LXPanel: This is LXDE's panel system, similar to GNOME's GNOME Panel or KDE's Kicker. it provides rapid access to applications, system tools, folders and the clipboard.

- LXSession: This is the LXDE session manager, which is responsible for starting and terminating the LXDE desktop environment.

- LXDE-OpenBox: This is a window editor that provides window layout and navigation.LXDE uses OpenBox as its default window editor.

- PCManFM: This is a lightweight file editor that provides file and folder browsing, copying, moving, deleting, etc.

In addition to these core components, LXDE has some other auxiliary tools, such as LXAppearance (for changing themes and logos), LXTask (task manager) and so on.

## Features on Ubuntu LXDE

### Audacity

**Audacity** is a free, open-source, cross-platform audio software that is used for recording, editing, and producing audio. It allows users to capture live audio, convert tapes and records into digital recordings, and edit audio files in a variety of formats. Audacity is widely used for tasks such as podcasting, music production, and audio analysis due to its user-friendly interface and powerful editing tools. It supports multi-track editing, numerous audio effects, and plugins, making it a popular choice for both amateurs and professionals.

![Audacity](Pictures/audacity.png)

To use Audacity, we need to select **audio-da7219** for both the microphone and audio hardware options. Additionally, set the **Project Rate** to **48000** to accommodate hardware limitations. After that, click the red circle button to start recording.

To export as MP3, follow the steps in the images below.
![Audacity](Pictures/save_audio_0.png)

Then we can fill metadata for the audio :

![Audacity](Pictures/save_audio_1.png)

Now, we can rename the audio file that has just been recorded. For example, I will choose `song.mp3`. After that, select the directory and click **Save** to store the audio file.

![Audacity](Pictures/save_audio_2.png)

### VLC Media Player
**VLC Media Player** is a free and open-source multimedia player that supports a wide range of audio and video formats. To play music, simply open VLC and follow these steps:

1. Launch **VLC Media Player**.
![VLC](Pictures/vlc.png)
2. Click on **Media** in the top menu, then select **Open File**.
![VLC](Pictures/vlc_open_0.png)
3. Browse to the location of **song.mp3**, select it, and click **Open** to start playing the music.
![VLC](Pictures/vlc_open_1.png)
4. Now, the media can be played using **VLC**.
![VLC](Pictures/vlc_open_2.png)

### Default Web Browser

Ubuntu LXDE comes with a default web browser pre-installed. This browser provides essential features for browsing the internet and is lightweight, making it suitable for low-resource systems.
![Browser](Pictures/web.png)

### Wifi
Ubuntu LXDE provides an easy way to connect to WiFi networks. Follow these simple steps to get connected:
1. **Click on the Network Icon**: In the lower-right corner of the screen, you will find the network icon. Click on this icon.
2. **Choose Your WiFi Network**: A list of available WiFi networks will appear. Find and click on your desired WiFi network from the list.
![Wifi](Pictures/wifi_0.png)
1. **Enter the Password**: After selecting the network, a prompt will appear asking for the WiFi password. Type in the password and click **Connect**.
2. **Connected**: Once the password is verified, your system will be connected to the WiFi network.

### Bluetooth

Ubuntu LXDE provides an easy way to connect to Bluetooth devices. Follow these simple steps to get connected:
1. **Click on the Bluetooth Icon**: In the lower-right corner of the screen, you will find the Bluetooth icon (usually a "B" symbol). Click on this icon, chosse `Devices..`.
![Bluetooth](Pictures/bluetooth_0.png)
   
2. **Turn On Bluetooth**: If Bluetooth is not already enabled, you may need to turn it on by clicking the **"Turn Bluetooth On"** option.

3. **Search for Device**: Choose Adapter, Search to get a list of available devices.
![Bluetooth](Pictures/bluetooth_1.png)
4. **Select Your Device**: A list of available Bluetooth devices will appear. Find and click on the device you wish to connect to.
![Bluetooth](Pictures/bluetooth_2.png)
![Bluetooth](Pictures/bluetooth_3.png)
5. **Pair the Device**: If prompted, confirm the pairing request and enter the required pairing code or PIN if necessary. After confirming, the devices will be paired.
![Bluetooth](Pictures/bluetooth_4.png)
4. **Connected**: Once the pairing process is completed, your device will be connected to the Bluetooth device.
