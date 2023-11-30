cd /usr/share/dockershell/
source src.d/colors.sh
source /usr/share/dockershell/development/src.d/commands.sh
source /usr/share/dockershell/development/src.d/dev.func.sh

banner

#shell loop
last_value=""
while true; do
    if [[ -f "/home/$USER/.reset_functions" ]]; then
        source /usr/share/dockershell/development/src.d/commands.sh
        rm /home/$USER/.reset_functions
        echo -e "Done!"
        # continue
    fi
    IFS= read -e -p "$(echo -ne "${tp}(${cyan}docker${red}:${green}devmod${tp})>${brown}")" value
    lock="0"
    [[ "$value" != "$last_value" ]]  && echo "docker $value" >> /home/$USER/.bash_history && history -s "$value" 
    last_value="$value" 
    lower_value="${value[@],,}"
    [[ "$lower_value" =~ ^(cls|clear) ]] && clear && banner && lock="1"
    #vars
    orginal_data="$value"
    array_data=($value)
    cmd_data="${array_data[0]}"
    params_data="${array_data[@]/$cmd_data}"
    ################################################################
    if type command_$cmd_data &> /dev/null 2>&1; then
        command_$cmd_data $params_data
    else
        [[ "$lock" = "0"  && "$value" != "" ]] && echo -e "${blue}" && bash -c "docker $value"
    fi
done


