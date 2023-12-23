#!/bin/bash

#Check permissions
if [ "$EUID" -eq 0 ]; then
    echo -e "${red}Please run this script as no root.${tp}"
    exit 1
fi

if [[ -f /usr/share/dockershell/dev.mod ]]; then
  bash /usr/share/dockershell/development/dev.main.sh
  exit 0
fi 

#check is installed for fisrt run
if ! [[ -d "/usr/share/dockershell/" ]]; then
  echo -e "Installing dockershell... \n\tPlease type the root password for installation..."
  sudo bash installer.sh
else
  if ! [[ -f /usr/bin/dockershell ]]; then
    echo -e "Installing dockershell... \n\tPlease type the root password for installation..."
    sudo cp /usr/share/dockershell/main.sh /usr/bin/dockershell
    ! [[ -f /usr/bin/dockershell ]] && echo -e "You must be cp /usr/bin/dockershell/main.sh to /usr/bin/dockershell" && exit 1
  fi
fi

#change work dir to system path
cd /usr/share/dockershell
source src.d/colors.sh

if ! [[ -f /tmp/dockershell.status ]]; then #if system running first time for new session
  #source
  source src.d/anim.sh
  #-----------------------
  source src.d/check_ver.sh
  source src.d/check_file.sh
  source src.d/check_req.sh
  source src.d/check_perm.sh
  
  echo "System checked" > /tmp/dockershell.status 
fi
echo -e "\r${tp}System is ready [${green}✓${tp}]         "

#change work dir to home
cd /home/$USER/
if [[ -f /usr/share/dockershell/pcf ]]; then
  source /usr/share/dockershell/docker.shell.sh
:
else
  echo -e "${tp}Now you can use ${cyan}DockerShell${tp} typing '${green}dockershell${tp}' command on your terminal."
  touch /usr/share/dockershell/pcf
:
fi
exit 0
