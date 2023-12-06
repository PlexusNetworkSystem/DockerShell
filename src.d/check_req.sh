#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No color

echo "" > /tmp/.anim.txt 

function install_docker() {
    # Install Docker
    sudo apt update 1> /dev/null
    sudo apt install docker.io -y 2> /tmp/dockershell.err 1> /dev/null 

    # Add the current user to the docker group
    sudo usermod -aG docker $USER 1> /dev/null

    if [ -x "$(command -v docker)" ]; then
        echo "pass" > /tmp/.anim.txt
    else
        echo "fail" > /tmp/.anim.txt   
    fi
}


function animation() {
    loading_anim_list=('/' '-' '\' '|')
    while ! [[ "$(cat /tmp/.anim.txt)" =~ (pass|fail) ]]; do
      for anim in ${loading_anim_list[@]}; do
        echo -ne "\r${tp}[${brown}DockerShell${tp}] ${blue}Installing $1 ${tp}[ ${purple}$anim ${tp}]${tp}"
        sleep 0.2
      done
    done
    echo -ne "\r"
    if [[ "$(cat /tmp/.anim.txt)" =~ "pass" ]]; then
        echo -e "${GREEN}Docker has been installed successfully.${NC}"
    else
        echo -e "${GREEN}Docker installation has been ${RED}failed ${GREEN}successfully.${NC}" 
        echo -e "_______________________/${blink}${RED}ERROR: ${cyan}Docker Installation ${RED}FAILED${tp}${stop_blink}\_______________________"
        cat /tmp/dockershell.err
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
        install_docker 2> /tmp/dockershell.err &
    else
        install_docker 2> /tmp/dockershell.err &
    fi
    
    animation "docker.io"

    # if classic process fail install docker.io
    if [[ "$(cat /tmp/.anim.txt)" =~ "fail" ]]; then
        echo -e "Docker Installation ${blink}${RED}FAILED${tp}${stop_blink}"
        exit 1
    fi
else
    echo -e "${GREEN}Docker is already installed.${NC}"
fi
