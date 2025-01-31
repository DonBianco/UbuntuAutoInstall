#!/bin/bash

# Check if the script is run as root (since we're changing system settings)
if [[ $(id -u) -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

# Prompt for new username, full name, and hostname
read -p "Enter new username: " new_username
read -p "Enter new full name: " new_full_name
read -p "Enter new hostname: " new_hostname

# Set the old username (assuming it's sslytherin, but change if needed)
old_username="sslytherin"

# 1. Create a temporary user to log into while renaming the `sslytherin` user
temp_user="tempuser"
useradd -m $temp_user
passwd $temp_user

echo "Logging out of the current user (sslytherin)..."
su - $temp_user -c "exit"

# 2. Change the Username
echo "Changing username from $old_username to $new_username..."
usermod -l "$new_username" "$old_username"

# 3. Rename the Home Directory
echo "Renaming home directory..."
mv "/home/$old_username" "/home/$new_username"
usermod -d "/home/$new_username" -m "$new_username"

# 4. Change the Full Name
echo "Changing full name to \"$new_full_name\"..."
chfn -f "$new_full_name" "$new_username"

# 5. Change the Hostname
echo "Changing system hostname to $new_hostname..."
hostnamectl set-hostname "$new_hostname"

# Update /etc/hosts
echo "Updating /etc/hosts to reflect the new hostname..."
sed -i "s/127.0.1.1\s*$old_username/127.0.1.1\t$new_hostname/" /etc/hosts

# 6. Delete the temporary user
echo "Deleting temporary user $temp_user..."
userdel -r $temp_user

# Success message
echo "Username, full name, and hostname have been successfully updated."
