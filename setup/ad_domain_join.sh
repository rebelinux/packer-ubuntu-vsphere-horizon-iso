#!/bin/bash

# Author: Jonathan Colon
# Date Created: 10/04/2023
# Last Modified: 30/04/2023

# Description
# First the script points the machine to the NTP server of the $NTPSERVER domain then adds the linux machine to the domain specified in the $ADDomain variable. 
# Finally it configures the automatic creation of the home directory for the users of the network

# Usage
# ad_domain_join

# Point NTP Server to AD Domain
printf "===> Pointing NTP Server to %s Domain\n" "$ADDomain"
sed -i /etc/systemd/timesyncd.conf -e "s/#NTP=/NTP=$NTPSERVER/g"
sudo systemctl restart systemd-timesyncd 2>&1

# Join AD Domain
printf "===> Join %s Active Directory Domain\n" "$ADDomain"
echo "$JOINPASSWORD" | sudo realm join --user="$JOINUSERNAME" "$ADDomain"

retval="$?"
if [ $retval -ne 0 ] 
then
    printf "Unable to add machine to domain %s \n" "$ADDomain"
else 
    # Disable use_fully_qualified_names in AD Login
    printf "===> Disable use_fully_qualified_names in AD Login\n"
    sed -i /etc/sssd/sssd.conf -e 's/use_fully_qualified_names = True/use_fully_qualified_names = False/g'

    # Add this line for SSO Login
    printf "===> Disable use_fully_qualified_names in AD Login\n"
    echo "ad_gpo_map_interactive = +gdm-vmwcred" >> /etc/sssd/sssd.conf
    echo "ad_gpo_access_control = permissive" >> /etc/sssd/sssd.conf

    # Automatic home directory creation for network users
    printf "===> Enable Automatic home directory creation for network users\n"
    echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
    sudo pam-auth-update --enable mkhomedir

    # Add user to sudoers file
    printf "===> Add user to sudoers file\n"
    echo ""%domain admins" ALL=(ALL) ALL" > "/etc/sudoers.d/$ADDomain"

    # Change "/etc/sudoers.d/$ADDomain" permissions
    printf "===> Change /etc/sudoers.d/%s permissions\n" $ADDomain
    chmod 440 "/etc/sudoers.d/$ADDomain"  
fi