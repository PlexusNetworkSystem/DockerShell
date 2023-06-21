#!/bin/bash 
if ! ping -c 1 google.com &> /dev/null; then
    echo "No internet connection. Version checking skipped."
else
    check=$(curl -sSL https://github.com/PlexusNetworkSystem/DockerShell/raw/main/version | tr -d '%')
    current_version="$(cat /usr/share/dockershell/version)"
    
    if [[ "$check" -gt "$current_version" ]]; then
        echo "New version available. Updating now..."
        
        status="none"
        while [[ "$status" = "1" ]] && echo "Process Failed, trying again"; do 
            sudo echo -e "Root auth success!"
            status="$?"
        done

        sudo rm -rf /usr/share/dockershell
        wget https://github.com/PlexusNetworkSystem/DockerShell/archive/refs/heads/main.zip
        unzip main.zip
        sudo rm main.zip
        cd DockerShell-main
        bash installer.sh
        echo "DockerShell updated to version $check"
    else
        echo "You are running the latest version of DockerShell."
    fi
fi


