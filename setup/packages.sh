#!/bin/bash

# Author: Jonathan Colon
# Date Created: 10/04/2020
# Last Modified: 30/04/2020

# Description
# This script installs commonly used applications

# Usage
# packages

# Updating APT
printf "===> Updating Apt\n"
apt-get -qq update 1> /dev/null

# Disable Ubuntu AutoUpdate
printf '===> Disable invalid v4l2loopback driver...\n'
echo "override v4l2loopback * extra" >> /etc/depmod.d/ubuntu.conf
depmod -A
sudo rmmod v4l2loopback 1> /dev/null

# Install Additional Packages
printf "===> Installing additional packages\n"
export DEBIAN_FRONTEND=noninteractive
apt-get -qq -y install      \
            acl             \
            aptitude        \
            bash-completion \
            ca-certificates \
            curl            \
            dnsutils        \
            gnupg           \
            lsb-release     \
            mlocate         \
            net-tools       \
            openssl         \
            pwgen           \
            resolvconf      \
            tldr            \
            unzip           \
            make            \
            gcc             \
            libelf-dev      \
            zenity          \
            ubuntu-desktop  1> /dev/null

if [ -z "$Additional_Packages" ]
then
    printf "===> Empty \$Aditional_Packages variable, disabling additional packages install\n"
else
    printf "===> Installing additional packages\n"
    apt-get -qq -y install $Additional_Packages 1> /dev/null
fi

# Updating MLocate database

is_pkg_installed=$(dpkg-query -W --showformat='${Status}\n' mlocate | grep "install ok installed")

if [ "${is_pkg_installed}" == "install ok installed" ];
then
    printf "===> Updating MLocate database\n"
    updatedb
fi
