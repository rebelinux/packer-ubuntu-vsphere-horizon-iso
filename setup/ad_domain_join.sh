#!/bin/bash

# Point NTP Server to AD Domain
echo "===> Pointing NTP Server to $ADDomain Domain"
sed -i /etc/systemd/timesyncd.conf -e "s/#NTP=/NTP=$NTPSERVER/g"
sudo systemctl restart systemd-timesyncd

# Join AD Domain
echo "===> Join $ADDomain Active Directory Domain"
echo $JOINPASSWORD | sudo realm join --user=$JOINUSERNAME $ADDomain\

# Disable use_fully_qualified_names in AD Login
echo "===> Disable use_fully_qualified_names in AD Login"
sed -i /etc/sssd/sssd.conf -e 's/use_fully_qualified_names = True/use_fully_qualified_names = False/g'

# Add this line for SSO Login
echo "===> Disable use_fully_qualified_names in AD Login"
echo "ad_gpo_map_interactive = +gdm-vmwcred" >> /etc/sssd/sssd.conf
echo "ad_gpo_access_control = permissive" >> /etc/sssd/sssd.conf


# Automatic home directory creation for network users
echo "===> Enable Automatic home directory creation for network users"
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
sudo pam-auth-update --enable mkhomedir