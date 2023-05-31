#!/bin/bash

#source
source src.d/colors.sh

#Check permissions
if [ "$EUID" -ne 0 ]; then
    echo -e "${red}Please run this script as root.${tp}"
    exit 1
fi

source src.d/check_file.sh

echo -e "Instaling system..."

#create directory
echo -e "Creating file dirs: /usr/share/dockershell.d"
sudo mkdir /usr/share/dockershell.d
while ! [[ -d /usr/share/dockershell.d ]]; do
  echo -e "ERROR: You have create: /usr/share/dockershell.d (press enter)"
  read nothing
done
chmod 777 /usr/share/dockershell.d
echo -e "\t└─> Successfully!"

#clone files
echo -e "Cloning files to: /usr/share/dockershell.d"
sudo cp -r * /usr/share/dockershell.d/
while ! [[ -f /usr/share/dockershell.d/main.sh ]]; do
  echo -e "ERROR: You have move files to: /usr/share/dockershell.d/ (press enter)"
  read nothing
done
echo -e "\t└─> Successfully!"

#set link file
echo -e "Linking main.sh as dockershell to: /usr/bin/dockershell"
sudo ln /usr/share/dockershell.d/main.sh /usr/bin/dockershell
while ! [[ -f /usr/bin/dockershell ]]; do
  echo -e "ERROR: You have link '/usr/share/dockershell.d/main.sh' to: /usr/bin/dockershell (press enter)"
  read nothing
done
sudo chmod +x /usr/bin/dockershell
sudo chmod 777 /usr/bin/dockershell
echo -e "\t└─> Successfully!"