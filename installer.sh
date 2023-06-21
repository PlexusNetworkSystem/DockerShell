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
echo -e "Creating file dirs: /usr/share/dockershell"
sudo mkdir /usr/share/dockershell
while ! [[ -d /usr/share/dockershell ]]; do
  echo -e "ERROR: You have create: /usr/share/dockershell(press enter)"
  read nothing
done
chmod 777 /usr/share/dockershell
echo -e "\t└─> Successfully!"

#clone files
echo -e "Cloning files to: /usr/share/dockershell"
sudo cp -r * /usr/share/dockershell/
while ! [[ -f /usr/share/dockershell/main.sh ]]; do
  echo -e "ERROR: You have move files to: /usr/share/dockershell/ (press enter)"
  read nothing
done
echo -e "\t└─> Successfully!"

#set link file
echo -e "Linking main.sh as dockershell to: /usr/bin/dockershell"
sudo ln /usr/share/dockershell/main.sh /usr/bin/dockershell
while ! [[ -f /usr/bin/dockershell ]]; do
  echo -e "ERROR: You have link '/usr/share/dockershell/main.sh' to: /usr/bin/dockershell (press enter)"
  read nothing
done
sudo chmod +x /usr/bin/dockershell
sudo chmod -R 777 /usr/bin/dockershell
 
# get dir name where the file is located without system dir names
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#DIR=${DIR##*/} #it's give just dir name of file located in. 
echo -e "Deleting: $DIR"
sudo rm -rf $DIR 

echo -e "\t└─> Successfully!"