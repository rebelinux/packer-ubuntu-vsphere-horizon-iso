#!/bin/bash

# Enable the boot splash
echo "===> Enable the boot splash"
sed -i /etc/default/grub -e 's/GRUB_CMDLINE_LINUX_DEFAULT=".*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/'
update-grub

# Enable ssh password auth and permit root login
echo "===> Enable ssh password auth and permit root login"
sed -i -e 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i -e 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config

# # Add user to sudoers file
# echo "===> Add user to sudoers file"
# echo "$BUILD_USERNAME ALL=(ALL) ALL" > "/etc/sudoers.d/$BUILD_USERNAME"

# # Change "/etc/sudoers.d/$BUILD_USERNAME" permissions
# echo "===> Change "/etc/sudoers.d/$BUILD_USERNAME" permissions"
# chmod 440 "/etc/sudoers.d/$BUILD_USERNAME"    

# Add user to sudoers file
echo "===> Add user to sudoers file"
echo ""%domain admins" ALL=(ALL) ALL" > "/etc/sudoers.d/$ADDomain"

# Change "/etc/sudoers.d/$ADDomain" permissions
echo "===> Change "/etc/sudoers.d/$ADDomain" permissions"
chmod 440 "/etc/sudoers.d/$ADDomain"   