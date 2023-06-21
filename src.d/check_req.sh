#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No color

function install_docker() {
    # Install Docker
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update
    sudo apt install -y docker-ce

    # Add the current user to the docker group
    sudo usermod -aG docker $USER

    if [ -x "$(command -v docker)" ]; then
        echo "done" > /home/$USER/.anim.txt 
    else
        echo "fail" > /home/$USER/.anim.txt   
    fi
}

function animation() {
    function animation() {
    loading_anim_list=('/' '-' '\' '|')
    while ! [[ "$(cat /home/$USER/.anim.txt)" =~ "done" ]]; do
      for anim in ${loading_anim_list[@]}; do
        echo -ne "\r${tp}[${brown}DockerShell${tp}] ${blue}Installing docker ${tp}[ ${purple}$anim ${tp}]${tp}"
        sleep 0.2
        if [[ "$(cat /home/$USER/.anim.txt)" =~ "done" ]]; then
            echo -e "${GREEN}Docker has been installed successfully.${NC}" && break
        else
            echo -e "${GREEN}Docker installation has been ${RED}failed ${GREEN}successfully.${NC}" 
            blink='\e[5m'
            stop_blink='\e[0m'
            echo -e "_______________________/${blink}${RED}ERROR: ${cyan}Docker Installation ${RED}FAILED${tp}${stop_blink}\_______________________"
            cat /home/$USER/dockershell.err
            echo -e "_________________________________________________________________________________"
            break
        fi 
      done
    done
}
}

# Check if Docker is already installed
if ! [ -x "$(command -v docker)" ]; then
    echo -e "${RED}Docker is not installed.${NC}"
    echo -e "${GREEN}Installing Docker...${NC}"
    # Check if user has sufficient permissions
    if [ "$EUID" -ne 0 ]; then
        read -e -p "$(echo -ne "${RED}Please type the sudo passwd!${NC}\n└─>")" passwd
        echo "$passwd" | sudo -S echo -e "Root auth getting..."
        install_docker 2> /home/$USER/dockershell.err &
    else
        install_docker 2> /home/$USER/dockershell.err &
    fi
    
    animation

else
    echo -e "${GREEN}Docker is already installed.${NC}"
fi
