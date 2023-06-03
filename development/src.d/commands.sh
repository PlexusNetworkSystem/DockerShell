command_unset() {
    if [[ "$lower_value" =~ "unset dev" ]]; then
        clear 
        banner
        echo -e "${blue}Dev Mod Passive!${tp}" 
        rm /usr/share/dockershell/dev.mod 
        exit 0
    fi 
}

command_exit() {
    echo -e "${red}Exiting ${cyan}Docker ${brown}Shell... ${green}Done${tp}" 
    exit 0
}

command_edit() {
    ! [[ -f $@ ]] && echo "ERROR: File not found!" && return 1
    nano "$@"
}

command_cd() {
    values="${@}/;"
    cd $@
    trycd="$(pwd)"
    #echo "trycd: $trycd" # Debugging
    ! [[ "$trycd" =~ ^(/usr/share/dockershell) ]] && echo -e "ERROR: Cannot cd to $trycd" && cd /usr/share/dockershell && return 1
}

command_cmd() { 
[[ "$@" =~ "help" ]] && echo -e "Type the shell commands." && return 0
while true; do
    IFS= read -e -p "$(echo -ne "${tp}(${cyan}docker${red}:${green}devmod${red}:${blue}cmd${tp})>${brown}")" value
    [[ "$value" != "$last_value" ]]  && echo "docker $value" >> /home/$USER/.bash_history && history -s "$value" 
    last_value="$value" 
    lower_value="${value[@],,}"
    [[ "$value" = "out" ]] && return 0
    $value
done
}

command_reset() {
    echo -e "Source repository..."
    touch /home/$USER/.reset_functions #operation not permitated
    return 0
}

command_usage() {
    echo "Usage: (docker:devmod)> cmd [options]"
    echo "       (docker:devmod)> edit [file]"
    echo "       (docker:devmod)> cd [directory]"
    echo "       (docker:devmod)> usage"
    echo "       (docker:devmod)> reset"
}