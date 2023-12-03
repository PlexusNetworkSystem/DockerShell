#!/bin/bash
#source
source src.d/colors.sh

#Check permissions
if [ "$EUID" -ne 0 ]; then
    echo -e "${red}Please run this script as root.${tp}"
    exit 1
fi

if [[ -f pcf ]];
  rm pcf
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


#Delete files
echo -e "Deleting files..."
rm -rf .
while ! [[ -f main.sh ]]; do
  echo -e "ERROR: You have delete files manually (press enter)"
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
sudo chmod 777 /usr/bin/dockershell
sudo chmod -R 777 /usr/share/dockershell
sudo chmod -R +x /usr/share/dockershell
echo -e "\t└─> Successfully!"