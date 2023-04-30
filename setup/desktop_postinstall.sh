#!/bin/bash

# Author: Jonathan Colon
# Date Created: 10/04/2020
# Last Modified: 30/04/2020

# Description
# This script modified content related to authentication (ssh & sudoers)

# Usage
# desktop_postinstall

# Enable the boot splash
echo "===> Enable the boot splash"
sed -i /etc/default/grub -e 's/GRUB_CMDLINE_LINUX_DEFAULT=".*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/'
update-grub &>/dev/null

# Enable ssh password auth and permit root login
echo "===> Enable ssh password auth and permit root login"
sed -i -e 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i -e 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config

# Add user to sudoers file
echo "===> Add user to sudoers file"
echo ""%domain admins" ALL=(ALL) ALL" > "/etc/sudoers.d/$ADDomain"

# Change "/etc/sudoers.d/$ADDomain" permissions
echo "===> Change "/etc/sudoers.d/$ADDomain" permissions"
chmod 440 "/etc/sudoers.d/$ADDomain"   