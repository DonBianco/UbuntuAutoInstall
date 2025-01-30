#!/bin/bash
echo "================================="
echo " Autoinstall USER Configuration!"
echo "================================="

# Traži od korisnika unos podataka
# Request user input for full name, username, and hostname
read -p "Enter user full name for example Salazar Slytherin: " FULLNAME
read -p "Enter username for example sslytherin: " USERNAME
read -p "Enter hostname please use Infobip standardization for example IB-SSLYTHERIN-L: " HOSTNAME

# Postavlja hostname
# Set the system hostname
echo "\$HOSTNAME" > /etc/hostname
hostnamectl set-hostname "\$HOSTNAME"

# Kreira novog korisnika
# Create the new user
adduser --gecos "\$FULLNAME" --disabled-password "\$USERNAME"
echo "\$USERNAME ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers.d/\$USERNAME

# Postavljanje lozinke za novog korisnika
# Set password for the new user
echo "\$USERNAME:Ovojetest12!" | chpasswd

# Premješta tempuser folder u novog korisnika
# Move tempuser folder to the new user
mv /home/tempuser /home/\$USERNAME
chown -R \$USERNAME:\$USERNAME /home/\$USERNAME

# Postavljanje lozinke za tempuser
# Set password for the tempuser
echo "tempuser:Ovojetest12!" | chpasswd

# Restart sistema da primijeni promjene
# Reboot the system to apply changes
echo "Setup completed, rebooting system Ciao!..."
sleep 3
reboot
