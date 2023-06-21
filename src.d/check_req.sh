#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No color

echo "" > /home/$USER/.anim.txt 

function install_docker() {
    # Install Docker
    if [[ "$1" = "second" ]]; then
        sudo apt install docker.io -y 2> /home/$USER/dockershell.err 1> /dev/null 
    else
        sudo apt update 1> /dev/null
        sudo apt install -y apt-transport-https ca-certificates curl software-properties-common 1> /dev/null
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - 1> /dev/null
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" 1> /dev/null
        sudo apt update 1> /dev/null
        sudo apt install -y docker-ce 1> /dev/null
    fi
    # Add the current user to the docker group
    sudo usermod -aG docker $USER 1> /dev/null

    if [ -x "$(command -v docker)" ]; then
        echo "pass" > /home/$USER/.anim.txt
    else
        echo "fail" > /home/$USER/.anim.txt   
    fi
}


function animation() {
    loading_anim_list=('/' '-' '\' '|')
    while ! [[ "$(cat /home/$USER/.anim.txt)" =~ (pass|fail) ]]; do
      for anim in ${loading_anim_list[@]}; do
        echo -ne "\r${tp}[${brown}DockerShell${tp}] ${blue}Installing $1 ${tp}[ ${purple}$anim ${tp}]${tp}"
        sleep 0.2
      done
    done
    echo -ne "\r"
    if [[ "$(cat /home/$USER/.anim.txt)" =~ "pass" ]]; then
        echo -e "${GREEN}Docker has been installed successfully.${NC}"
    else
        echo -e "${GREEN}Docker installation has been ${RED}failed ${GREEN}successfully.${NC}" 
        blink='\e[5m'
        stop_blink='\e[0m'
        echo -e "_______________________/${blink}${RED}ERROR: ${cyan}Docker Installation ${RED}FAILED${tp}${stop_blink}\_______________________"
        cat /home/$USER/dockershell.err
        echo -e "_________________________________________________________________________________"
    fi 
}


# Check if Docker is already installed
if ! [ -x "$(command -v docker)" ]; then
    echo -e "${RED}Docker is not installed.${NC}"
    echo -e "${GREEN}Installing Docker...${NC}"
    # Check if user has sufficient permissions
    if [ "$EUID" -ne 0 ]; then
        root_per_status="none"
        while [[ "$status" = "1" ]] && echo "Process Failed, trying again"; do 
            sudo echo -e "${green}Root auth success!${tp}"
            root_per_status="$?"
        done
        install_docker first 2> /home/$USER/dockershell.err &
    else
        install_docker first 2> /home/$USER/dockershell.err &
    fi
    
    animation "docker(docker.com)"

    # if classic process fail install docker.io
    if [[ "$(cat /home/$USER/.anim.txt)" =~ "fail" ]]; then
        echo "" > /home/$USER/dockershell.err
        echo "" > /home/$USER/.anim.txt
        install_docker second 2> /home/$USER/dockershell.err &
        animation "docker.io"
    fi
else
    echo -e "${GREEN}Docker is already installed.${NC}"
fi
