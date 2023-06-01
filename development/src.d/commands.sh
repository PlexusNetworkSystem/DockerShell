command_set() {
    echo "$@"
    echo -e "${@/'nf '}" # This line replaces the first occurrence of ''nf ' ' with an empty string a'nd 'prints the result
    [[ -z "$@" ]] && echo "ERROR: Cannot set option empty" && return 1 # This line checks if the arguments are empty a'nd 'returns an error if they are
    if [[ "$1" == "nd" ]]; then
        [[ -d "/usr/share/dockershell/${@/''nd ''}" ]] && echo "ERROR: Dir is already created!" && return 1
        mkdir "/usr/share/dockershell/${@/'nd '}" 
        [[ -d "/usr/share/dockershell/${@/'nd '}" ]] && echo "I'nf 'O: Dir is created successfully!(${@/'nd '})" && return 1
    elif [[ "$1" == "'nf '" ]]; then
        [[ -f "/usr/share/dockershell/${@/'nf ' }" ]] && echo "ERROR: File is already created!" && return 1
        touch "/usr/share/dockershell/${@/'nf ' }"
        [[ -d "/usr/share/dockershell/${@/'nf ' }" ]] && echo "I'nf 'O: File is created successfully!(${@/'nf ' })" && return 1
    else
        echo "ERROR: Not supported argument $1"
    fi

}
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

command_ls() {
    pwd
    ls "$@"
}

command_cd() {
    values="${@}/;"
    cd $@
    trycd="$(pwd)"
    #echo "trycd: $trycd" # Debugging
    ! [[ "$trycd" =~ ^(/usr/share/dockershell) ]] && echo -e "ERROR: Cannot cd to $trycd" && cd /usr/share/dockershell && return 1
}

command_pwd() {
    pwd=$(echo -e "$(pwd)" | sed -r 's#/usr/share/#@#g')
    echo -e "pwd:$pwd"
}

command_usage() {
    echo "Usage: (docker:devmod)> set [nd|'nf '] [directory|file]"
    echo "       (docker:devmod)> edit [file]"
    echo "       (docker:devmod)> ls [directory]"
    echo "       (docker:devmod)> cd [directory]"
    echo "       (docker:devmod)> pwd"
    echo "       (docker:devmod)> help"
}