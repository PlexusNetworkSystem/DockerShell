cd /usr/share/dockershell/
source src.d/colors.sh
source /usr/share/dockershell/development/src.d/commands.sh

#banner
function banner() {
echo -ne "${cyan}"
echo -ne '
  __   __   __        ___  __      __        ___           
 |  \ /  \ /  ` |__/ |__  |__)    /__` |__| |__  |    |    
 |__/ \__/ \__, |  \ |___ |  \    .__/ |  | |___ |___ |___'
echo -e "\tversion: $(cat /usr/share/dockershell/version)"
echo -ne "${tp}"
echo -e "${green}               Welcome the Docker Shell!"
echo -e "${green}               Type usage for get list of commands\n"
}

banner

#shell loop
last_value=""
while true; do
    if [[ -f "/home/$USER/.reset_functions" ]]; then
        echo -e "Done!"
        rm /home/$USER/.reset_functions
        source /usr/share/dockershell/development/src.d/commands.sh
        break
    fi
    IFS= read -e -p "$(echo -ne "${tp}(${cyan}docker${red}:${green}devmod${tp})>${brown}")" value
    lock="0"
    [[ "$value" != "$last_value" ]]  && echo "docker $value" >> /home/$USER/.bash_history && history -s "$value" 
    last_value="$value" 
    lower_value="${value[@],,}"
    [[ "$lower_value" =~ ^(cls|clear) ]] && clear && banner && echo -e "${blue}Cleared!${tp}" && lock="1"
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