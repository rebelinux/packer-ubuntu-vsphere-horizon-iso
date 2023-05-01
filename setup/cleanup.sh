#!/bin/bash

# Author: Jonathan Colon
# Date Created: 10/04/2023
# Last Modified: 30/04/2023

# Description
# This script is the final sealing process. It is cleaning the machine preparing it for instant horizon cloning.

# Usage
# cleanup

printf '"===>  Cleaning all audit logs ...\n'
if [ -f /var/log/audit/audit.log ]; then
cat /dev/null > /var/log/audit/audit.log
fi
if [ -f /var/log/wtmp ]; then
cat /dev/null > /var/log/wtmp
fi
if [ -f /var/log/lastlog ]; then
cat /dev/null > /var/log/lastlog
fi
# Cleans SSH keys.
printf '"===>  Cleaning SSH keys ...\n'
rm -f /etc/ssh/ssh_host_*

# Desktop Cleanup
# Remove default filesystem and related tools not used with the suggested
# 'direct' storage layout.  These may yet be required if different
# partitioning schemes are used.

printf "===> Remove default filesystem and related tools not used with the suggested\n"
apt-get -qq remove -y btrfs-progs cryptsetup* lvm2 xfsprogs 1> /dev/null

# Remove other packages present by default in Ubuntu Server but not
# normally present in Ubuntu Desktop.
printf "===> Remove other packages present by default in Ubuntu Server but not normally present in Ubuntu Desktop\n"
apt-get -qq -y remove           \
        ubuntu-server           \
        ubuntu-server-minimal   \
        binutils                \
        byobu                   \
        dmeventd                \
        finalrd                 \
        gawk                    \
        kpartx                  \
        mdadm                   \
        ncurses-term            \
        open-iscsi              \
        sg3-utils               \
        thin-provisioning-tools \
        vim                     \
        tmux                    \
        sosreport               \
        screen                  \
        motd-news-config        \
        lxd-agent-loader        \
        landscape-common        \
        htop                    \
        git                     \
        fonts-ubuntu-console    \
        ethtool                 \
        gnome-initial-setup     \
        make                    \
        gcc                     \
        libelf-dev 1> /dev/null

# Cleans apt-get.
printf '"===>  Cleaning apt-get ...\n'
apt-get clean 1> /dev/null
apt-get autoremove -y 1> /dev/null

# Disable Ubuntu AutoUpdate
printf '"===>  Disable Ubuntu AutoUpdate...\n'
sed -i /etc/apt/apt.conf.d/20auto-upgrades -e 's/APT::Periodic::Update-Package-Lists "1";/APT::Periodic::Update-Package-Lists "0";/g'
sed -i /etc/apt/apt.conf.d/20auto-upgrades -e 's/APT::Periodic::Unattended-Upgrade "1";/APT::Periodic::Unattended-Upgrade "0";/g'

# Cleans the machine-id.
printf '"===>  Cleaning the machine-id ...\n'
truncate -s 0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

# optional: cleaning cloud-init
printf '"===>  Cleaning cloud-init\n'
rm -rf /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
rm -rf /etc/cloud/cloud.cfg.d/99-installer.cfg
echo 'datasource_list: [ VMware, NoCloud, ConfigDrive ]' | tee /etc/cloud/cloud.cfg.d/90_dpkg.cfg
/usr/bin/cloud-init clean
