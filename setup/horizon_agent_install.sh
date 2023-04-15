#!/bin/bash

# Extracting VMware Horizon Agent files
if [ -d "/tmp/VMware-horizonagent-linux-x86_64-*" ]
then
    echo "===> Extracting VMware Horizon Agent files"
    cd "/tmp"
    tar -zxf VMware-horizonagent-linux-x86_64-*
    # Downloading V4L2Loopback driver files
    echo "===> Downloading VHCI-HCD driver files"
    wget --quiet "https://github.com/umlaeute/v4l2loopback/archive/refs/tags/v0.12.5.tar.gz"
    # Downloading VHCI-HCD driver files
    echo "===> Downloading VHCI-HCD driver files"
    wget --quiet https://sourceforge.net/projects/usb-vhci/files/linux%20kernel%20module/vhci-hcd-1.15.tar.gz/download -O "vhci-hcd-1.15.tar.gz"
else
    echo "===> Error: Directory /tmp/VMware-horizonagent-linux-x86_64-* does not exists."
    echo "===> Error: Unable to extract VMware Horizon Agent files"
fi


# Adding support for Horizon Real-Time Audio-Video
if [ -f "v0.12.5.tar.gz" ]
then
    # Extracting V4L2Loopback driver files
    echo "===> Extracting V4L2Loopback driver files"
    tar -zxf "v0.12.5.tar.gz"

    # Patching V4L2Loopback driver files
    echo "===> Patching V4L2Loopback driver files"
    cd "v4l2loopback-0.12.5/"
    patch -p1 < "/tmp/VMware-horizonagent-linux-x86_64-*/resources/v4l2loopback/v4l2loopback.patch"

    # Compiling V4L2Loopback driver files
    echo "===> Extracting V4L2Loopback driver files"
    make clean && make && make install

    # Installing v4l2loopback-ctl
    echo "===> Installing v4l2loopback-ctl"
    make install-utils
    depmod -A
else
    echo "===> Error: File v0.12.5.tar.gz does not exists."
    echo "===> Error: Unable to compile and install V4L2Loopback driver"
    echo "===> Error: Disable support for Horizon Real-Time Audio-Video"
fi

# Adding support for Horizon USB redirection
if [ -f "vhci-hcd-1.15.tar.gz" ]
then
    # Extracting VHCI-HCD driver files
    echo "===> Extracting VHCI-HCD driver files"
    tar -zxf "vhci-hcd-1.15.tar.gz"

    # Patching VHCI-HCD driver files
    echo "===> Extracting VHCI-HCD driver files"
    cd "vhci-hcd-1.15"
    patch -p1 < "/tmp/VMware-horizonagent-linux-x86_64-*/resources/vhci/patch/vhci.patch"

    # Compiling VHCI-HCD driver files
    echo "===> Extracting VHCI-HCD driver files"
    make clean && make && make install
else
    echo "===> Error: File vhci-hcd-1.15.tar.gz does not exists."
    echo "===> Error: Unable to compile and install VHCI-HCD driver"
    echo "===> Error: Disable support for Horizon USB redirection"
fi

# Installing Horizon Agent
if [ -d "/tmp/VMware-horizonagent-linux-x86_64-*" ]
then
    echo "===> Installing Horizon Agent"
    cd "/tmp/VMware-horizonagent-linux-x86_64-*/"

    if [ -d "/tmp/VMware-horizonagent-linux-x86_64-*" ]
    then
        ./install_viewagent.sh -A yes -U yes -a yes --webcam
    else
        echo "===> Error: Directory /tmp/VMware-horizonagent-linux-x86_64-* does not exists."
        echo "===> Error: Unable to install Horizon"
    fi
else
    echo "===> Error: Directory /tmp/VMware-horizonagent-linux-x86_64-* does not exists."
    echo "===> Error: Unable to install Horizon"
fi

# Setting SSSD authentication (OfflineJoinDomain=sssd)
if [ -f "/etc/vmware/viewagent-custom.conf" ]
then
    echo "===> Setting SSSD authentication (OfflineJoinDomain=sssd)"
    echo "OfflineJoinDomain=sssd" >> "/etc/vmware/viewagent-custom.conf"
else
    echo "===> Error: File vhci-hcd-1.15.tar.gz does not exists."
fi