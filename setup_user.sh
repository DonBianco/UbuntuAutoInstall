#!/bin/bash

set -e  # Exit on error

# Function to check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root." >&2
    exit 1
fi

# Prompt user for new values
read -p "Please enter new hostname: " new_hostname
read -p "Please enter new username: " new_username
read -p "Please enter full name: " new_fullname

# Get current username and hostname
old_username=$(whoami)
old_hostname=$(hostname)

echo "Changing hostname from $old_hostname to $new_hostname..."
echo "$new_hostname" > /etc/hostname
hostnamectl set-hostname "$new_hostname"
sed -i "s/^127.0.1.1.*/127.0.1.1    $new_hostname/g" /etc/hosts

# Change full name
usermod -c "$new_fullname" "$old_username"

echo "Changing username from $old_username to $new_username..."
if [[ "$old_username" != "$new_username" ]]; then
    usermod -l "$new_username" "$old_username"
    usermod -d "/home/$new_username" -m "$new_username"
fi

# Inform the user
echo "All changes applied successfully. Rebooting now..."
sleep 3
reboot
