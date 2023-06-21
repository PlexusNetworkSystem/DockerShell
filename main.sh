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
  status="none"
  while [[ "$status" = "1" ]] && echo "Process Failed, trying again"; do 
      sudo echo -e "${green}Root auth success!${tp}"
      status="$?"
  done
  sudo bash installer.sh
else
  if ! [[ -f /usr/bin/dockershell ]]; then
    echo -e "Installing dockershell... \n\tPlease type the root password for installation..."
    sudo cp /usr/share/dockershell/main.sh /usr/bin/dockershell
    [[ -f /usr/bin/dockershell ]] && echo -e "You must be cp /usr/bin/dockershell/main.sh to /usr/bin/dockershell" && exit 1
  fi
fi



#change work dir to system path
cd /usr/share/dockershell

#source
source src.d/colors.sh
source src.d/check_ver.sh
source src.d/check_file.sh
source src.d/check_req.sh

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


