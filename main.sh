#!/bin/bash


#Check permissions
if [ "$EUID" -eq 0 ]; then
    echo -e "${red}Please run this script as no root.${tp}"
    exit 1
fi

#check is installed for fisrt run
if ! [[ -d "/usr/share/dockershell.d/" ]]; then
  echo -e "Installing dockershell... \n\tPlease type the root password for installation..."
  sudo bash installer.sh
else
  if ! [[ -f /usr/bin/dockershell ]]; then
    echo -e "Installing dockershell... \n\tPlease type the root password for installation..."
    sudo cp /usr/share/dockershell.d/main.sh /usr/bin/dockershell
    [[ -f /usr/bin/dockershell ]] && echo -e "You must be cp /usr/bin/dockershell.d/main.sh to /usr/bin/dockershell" && exit 1
  fi
fi

! [[ -d "/usr/share/dockershell.d" || -f /usr/bin/dockershell ]] && echo -e "System: You have install system!"  && exit 1


#change work dir to system path
cd /usr/share/dockershell.d

source src.d/check_file.sh

#source
source src.d/check_req.sh
source src.d/colors.sh


#change work dir to home
cd /home/$USER/
if [[ -f /usr/share/dockershell.d/pcf ]]; then
  source /usr/share/dockershell.d/docker.shell.sh
:
else
  echo -e "${tp}Now you can use ${cyan}DockerShell${tp} typing '${green}dockershell${tp}' command on your terminal."
  touch /usr/share/dockershell.d/pcf
:
fi