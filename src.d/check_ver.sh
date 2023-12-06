#!/bin/bash 
anim_start "Checking connection" &
sleep 0.5


function update() {
        echo "true" > /tmp/ds_upd_val.txt
        sudo rm -rf /usr/share/dockershell
        sudo rm -rf /usr/bin/dockershell
        wget https://github.com/PlexusNetworkSystem/DockerShell/archive/refs/heads/main.zip
        unzip main.zip
        cd DockerShell-main
        bash main.sh
        cd ..
        rm main.zip
        rm -rf DockerShell-main
        echo "false" > /tmp/ds_upd_val.txt
}
function check_update() {
    while $(cat /tmp/ds_upd_val.txt); do
    sleep 0.2
    done
    anim_stop
    if [[ -d /usr/share/dockershell ]]; then
        echo -e "! DockerShell updated to version $check !"
        anim_start "Switching file check"
    else
        echo -e "${red} Has error an accoured!${tp}"
        cat /tmp/ds_update_err.rtx
        exit 1
    fi
    sleep 1
}

if ! ping -c 1 google.com &> /dev/null; then
    anim_stop
    echo "No internet connection. Version checking skipped."
else
    anim_change "Checking new version"
    #echo -ne "\r${blue}Checking ${brown}new version...${tp}"
    curl -sSL https://github.com/PlexusNetworkSystem/DockerShell/raw/main/version -o /tmp/dockershell_version.txt &> /dev/null
    cd /home/$USER/  
    if [[ "$(cat /tmp/dockershell_version.txt | tr -d '%')" != "$(cat /usr/share/dockershell/version)" ]]; then
        anim_stop
        echo -e "${green}New version available. ${blue}Need sudo for update${tp}"
        sudo echo -ne "\r validating..."
        update &> /dev/null &
        anim_start "Updating now" &
        check_update 
    fi
    cd /usr/share/dockershell
fi



