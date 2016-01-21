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
sed 's/cmy-ThinkPad-T430/walle/g' /etc/hosts > /tmp/__hosts
mv /tmp/__hosts /etc/hosts
chmod 0644 /etc/hosts
sed 's/cmy-ThinkPad-T430/walle/g' /etc/hostname > /tmp/__hostname
mv /tmp/__hostname /etc/hostname
chmod 0644 /etc/hostname

# Install deb
apt-get -y install sudo dosfstools ntfs-3g
apt-get -y install isc-dhcp-client net-tools iputils-arping iputils-ping openssh-server
apt-get -y install wireless-tools wpasupplicant
apt-get clean

# sudo without password
sed 's/%sudo\tALL=(ALL:ALL) ALL/%sudo\tALL=(ALL:ALL) NOPASSWD: ALL/g' /etc/sudoers > /tmp/__sudoers
mv /tmp/__sudoers /etc/sudoers
chmod 0440 /etc/sudoers

# do something in booting
sed 's/exit 0//g' /etc/rc.local > /tmp/__rc.local
echo "/usr/local/bin/mtd-by-name.sh" >> /tmp/__rc.local
echo "/usr/local/bin/first-boot-recovery.sh" >> /tmp/__rc.local
echo "exit 0" >> /tmp/__rc.local
mv /tmp/__rc.local /etc/rc.local
chmod 0755 /etc/rc.local

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
sed 's/sleep/#sleep/g' /etc/init/failsafe.conf > /tmp/__failsafe.conf
mv /tmp/__failsafe.conf /etc/init/failsafe.conf
chmod 0644 /etc/init/failsafe.conf
