#!/bin/bash

# Author: Jonathan Colon
# Date Created: 10/04/2023
# Last Modified: 30/04/2023

# Description
# This script modified content related to authentication (ssh & sudoers)

# Usage
# desktop_postinstall

# Enable the boot splash
printf "===> Enable the boot splash\n"
sed -i /etc/default/grub -e 's/GRUB_CMDLINE_LINUX_DEFAULT=".*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/'
update-grub &>/dev/null

# Enable ssh password auth and permit root login
printf "===> Enable ssh password auth and permit root login\n"
sed -i -e 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i -e 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config 