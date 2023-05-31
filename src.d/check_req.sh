#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No color

# Check if Docker is already installed
if ! [ -x "$(command -v docker)" ]; then
    echo -e "${RED}Docker is not installed.${NC}"
    echo -e "${GREEN}Installing Docker...${NC}"
    
    # Check if user has sufficient permissions
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Please run this script as root.${NC}"
        exit 1
    fi
    
    # Install Docker
    apt update
    apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt update
    apt install -y docker-ce

    # Add the current user to the docker group
    usermod -aG docker $USER

    echo -e "${GREEN}Docker has been installed successfully.${NC}"
else
    echo -e "${GREEN}Docker is already installed.${NC}"
fi
