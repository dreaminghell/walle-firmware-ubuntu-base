#!/bin/bash

# setup environment
mount none -t proc /proc
mount none -t sysfs /sys
mount none -t devpts /dev/pts
export HOME=/root
export LC_ALL=C

# add user for walle
useradd -m walle
echo "walle:walle" | chpasswd
adduser walle sudo

# change hostname
sed -i '/127.0.1.1/s/^.*$/127.0.1.1       walle/' /etc/hosts
echo "walle" > /etc/hostname

# Install deb
apt-get -y install sudo dosfstools ntfs-3g
apt-get -y install isc-dhcp-client net-tools iputils-arping iputils-ping openssh-server
apt-get -y install wireless-tools wpasupplicant
apt-get -y install vim strace file wget less man
apt-get -y install alsa-utils sox libsox-fmt-all
apt-get clean

# sudo without password
sed -i 's/%sudo\tALL=(ALL:ALL) ALL/%sudo\tALL=(ALL:ALL) NOPASSWD: ALL/g' /etc/sudoers

# do something in booting
sed -i 's/exit 0//g' /etc/rc.local
echo "/usr/local/bin/mtd-by-name.sh" >> /etc/rc.local
echo "/usr/local/bin/first-boot-recovery.sh" >> /etc/rc.local
echo "insmod /lib/modules/brcmutil.ko" >> /etc/rc.local
echo "insmod /lib/modules/brcmfmac.ko" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local

# autoconfig network
echo "auto lo" >> /etc/network/interfaces
echo "iface lo inet loopback" >> /etc/network/interfaces
echo "auto eth0" >> /etc/network/interfaces
echo "iface eth0 inet dhcp" >> /etc/network/interfaces

# autoconfig wifi
echo "ctrl_interface=/var/run/wpa_supplicant" >> /etc/wpa_supplicant.conf
echo "ap_scan=1" >> /etc/wpa_supplicant.conf

echo "auto wlan0" >> /etc/network/interfaces
echo "allow-hotplug wlan0" >> /etc/network/interfaces
echo "iface wlan0 inet dhcp" >> /etc/network/interfaces
echo "pre-up wpa_supplicant -iwlan0 -c/etc/wpa_supplicant.conf -s -B" >> /etc/network/interfaces
echo "post-down pkill wpa_supplicant" >> /etc/network/interfaces

# don't wait network in system booting.
sed -i 's/sleep/#sleep/g' /etc/init/failsafe.conf
