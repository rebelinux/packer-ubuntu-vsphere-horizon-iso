#!/bin/bash

# Updating APT
echo "===> Updating Apt"
apt-get -qq update

# Disable Ubuntu AutoUpdate
echo '> Disable invalid v4l2loopback driver...'
echo "override v4l2loopback * extra" >> /etc/depmod.d/ubuntu.conf
depmod -A
sudo rmmod v4l2loopback

# Install Additional Packages
echo "===> Installing additional packages"
export DEBIAN_FRONTEND=noninteractive
apt-get -qq install -y      \
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
            ubuntu-desktop  
  
# Updating MLocate database

is_pkg_installed=$(dpkg-query -W --showformat='${Status}\n' mlocate | grep "install ok installed")

if [ "${is_pkg_installed}" == "install ok installed" ];
then
    echo "===> Updating MLocate database"
    updatedb
fi
