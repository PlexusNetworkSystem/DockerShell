#check is files there
echo -e "System: ${blue}Checking files...${tp}"
function check_files() {
 ! [[ -f $1 ]] && echo -e "File(${brown}$1${tp}) Not found! Exiting.." && exit 1
}
function check_dir() {
 ! [[ -d $1 ]] && echo -e "Diractory(${brown}$1${tp}) Not found! Exiting.." && exit 1
}
check_files "installer.sh"
check_files "main.sh"
check_dir "src.d/"
check_files "src.d/check_req.sh"
check_files "src.d/colors.sh"

echo -e "System: ${green}All files installed.${tp}"