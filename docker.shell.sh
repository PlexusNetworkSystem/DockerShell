#banner
function banner() {
echo -ne "${cyan}"
echo -ne '
  __   __   __        ___  __      __        ___           
 |  \ /  \ /  ` |__/ |__  |__)    /__` |__| |__  |    |    
 |__/ \__/ \__, |  \ |___ |  \    .__/ |  | |___ |___ |___'
echo -e "\tversion: $(cat /usr/share/dockershell/version)" 
echo -ne "${tp}"
echo -e "${green}               Welcome the Docker Shell!\n"
}

banner

#shell loop
last_value=""
while true; do
IFS= read -e -p "$(echo -ne "${tp}(${cyan}docker${tp})>${brown}")" value
lock="0"
[[ "$value" != "$last_value" ]]  && echo "docker $value" >> /home/$USER/.bash_history && history -s "$value" 
last_value="$value" 
lower_value="${value[@],,}"
[[ "$lower_value" = "exit" ]] && echo -e "${red}Exiting ${cyan}Docker ${brown}Shell... ${green}Done${tp}" && exit 0 
[[ "$lower_value" =~ ^(cls|clear) ]] && clear && banner && echo -e "${blue}Cleared!${tp}" && lock="1"
if [[ "$lower_value" =~ "set dev" ]]; then
clear 
banner
echo -e "${blue}Dev Mod Acitve!${tp}" 
touch /usr/share/dockershell/dev.mod 
exit 0
fi 
 
[[ "$lock" = "0"  && "$value" != "" ]] && echo -e "${blue}" && bash -c "docker $value"
done