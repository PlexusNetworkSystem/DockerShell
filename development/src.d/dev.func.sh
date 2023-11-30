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