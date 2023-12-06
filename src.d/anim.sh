# load animation 
echo "true" > /tmp/dockershell_anim_status.txt
anim_label=("|" "/" "—" "\\\\")

function anim_line_clear() {
    echo -e "\r                          "
}

function anim_start() {
    echo "$@" > /tmp/dockershell_anim_value.txt
    while $(cat /tmp/dockershell_anim_status.txt); do
    value="$(cat /tmp/dockershell_anim_value.txt)"
        for i in "${anim_label[@]}"; do
            echo -ne "\r${brown}$value ${blue}[${green}$i${blue}]${tp}      "
            sleep 0.1
        done
    done
    anim_line_clear
}

function anim_stop() {
    echo "false" > /tmp/dockershell_anim_status.txt
    sleep 0.5
}

function anim_change() {
    # clear line / change value    
    echo "$@" > /tmp/dockershell_anim_value.txt
    sleep 0.1
    
}

