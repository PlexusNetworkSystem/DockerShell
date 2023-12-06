
file_path="/var/run/docker.sock"

while [ "$(stat -c "%a" "$file_path")" != "777" ]; do
        # Set the permissions using sudo
        if [[ -f /usr/bin/pkexec ]]; then
            anim_change "Waiting password"
            pkexec chmod 777 "$file_path"
        else
            anim_stop
            read -e -p "$(echo -ne "Type sudo password for get access to docker: ")" sudo_passwd
            echo $sudo_passwd | sudo -S chmod 777 "$file_path"
        fi
done
anim_stop