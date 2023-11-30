file_path="/var/run/docker.sock"

while [ "$(stat -c "%a" "$file_path")" != "777" ]; do
        # Set the permissions using sudo
        if [[ -f /usr/bin/zenity ]]; then
            sudo_passwd=$(zenity --entry --title="Sudo Password" --text="Type sudo password for access to Docker:")
        else
            read -e -p "$(echo -ne "Type sudo password for get access to docker: ")" sudo_passwd
        fi
        echo $sudo_passwd | sudo -S chmod 777 "$file_path"
done
