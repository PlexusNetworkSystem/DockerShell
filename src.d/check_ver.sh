#!/bin/bash 
if ! ping -c 1 google.com &> /dev/null; then
    echo "No internet connection. Version checking skipped."
    sleep 1
else
    cd /home/$USER/
    echo -ne "\r${blue}Checking ${brown}new version...${tp}"
    sleep 1
    check=$(curl -sSL https://github.com/PlexusNetworkSystem/DockerShell/raw/main/version | tr -d '%')
    current_version="$(cat /usr/share/dockershell/version)"
    
    if [[ "$check" != "$current_version" ]]; then
        echo -e "\r${green}New version available. ${blue}Updating now...${tp}"
        
        status="none"
        while [[ "$status" = "1" ]] && echo "Process Failed, trying again"; do 
            sudo echo -e "${green}Root auth success!${tp}"
            status="$?"
        done

        sudo rm -rf /usr/share/dockershell
        sudo rm -rf /usr/bin/dockershell
        wget https://github.com/PlexusNetworkSystem/DockerShell/archive/refs/heads/main.zip
        unzip main.zip
        cd DockerShell-main
        bash main.sh
        rm main.zip
        rm -rf DockerShell-main
        cd ..
        echo -ne "\r"
        echo -e "DockerShell updated to version $check"
    else
        echo -ne "\r"
        echo -e "${tp}You are running the ${blue}latest version ${tp}of ${cyan}DockerShell${tp}."
    fi
    cd /usr/share/dockershell
fi



