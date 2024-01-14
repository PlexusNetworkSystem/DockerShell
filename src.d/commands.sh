#command_pcf
function command_help() {
    if [[ -z $1 ]]; then
        echo -e "${green}Usage of help${tp}"
        echo -e "help       -> display this help message"
        echo -e "help -a    -> display All docker commands"
        echo -e "help <cmd> -> display usage"
        echo -e "list       -> list images or containers"
        echo -e "run        -> run a container"  
    else
        if [[ $1 =~ (-a|all) ]]; then
            less /usr/share/dockershell/src.d/dockerhelp.src
        else
            common_commands=("run" "exec" "ps" "build" "pull" "push" "images" "login" "logout" "search" "version" "info")
            management_commands=("builder" "container" "context" "image" "manifest" "network" "plugin" "system" "trust" "volume")
            swarm_commands=("swarm")
            additional_commands=("attach" "commit" "cp" "create" "diff" "events" "export" "history" "import" "inspect" "kill" "load" "logs" "pause" "port" "rename" "restart" "rm" "rmi" "save" "start" "stats" "stop" "tag" "top" "unpause" "update" "wait")
            if [[ " ${common_commands[@]} " =~ "$1" ]]; then
                docker $1 --help
            elif [[ " ${management_commands[@]} " =~ "$1" ]]; then
                docker $1 --help
            elif [[ " ${swarm_commands[@]} " =~ "$1" ]]; then
                docker $1 --help
            elif [[ " ${additional_commands[@]} " =~ "$1" ]]; then
                docker $1 --help 
            fi
        fi
    fi

}

function command_list() {
    if [[ "$1" == "all" ]]; then
        echo -e "${blue}Images${tp}"
        docker images
        echo -e "${blue}Containers${tp}"
        docker ps -as
    elif [[ "$1" =~ (img|image)  ]]; then
        echo -e "${blue}Images${tp}"
        docker images
    elif [[ "$1" =~ (con|containers)  ]]; then
        echo -e "${blue}Containers${tp}"
        docker ps -as
    elif [[ "$1" =~ (-h|--help)  ]]; then
        echo -e "${blue}Usage${tp}"
        echo -e "list all -> list All"
        echo -e "list con -> list containers"
        echo -e "list img -> list images"
    else
        docker ps
    fi 
}  
function command_run() {
    if [[ "$1" =~ (-h|--help) ]] || [[ -z "$1" ]]; then
        echo -e "${green}Usage of run${tp}"
        echo -e "run <container id or name>    : run the container"
        echo -e "run <container id or name> -c : run and open console screen on container"
        return 0
        :
    else
        if ! [[ "$(docker ps -aq -f name=$1)" || "$(docker ps -aq -f id=$1)" ]]; then
            docker run $@ && return 0 
        fi
        #Is the first parameter not existing as container it is possibly an paramter command of docker run. Also it is not an parameter and not existing container, docker run command returning error automatically
        :
    fi

    if [ "$(docker ps -aq -f status=running -f name=$1)" ] || [ "$(docker ps -aq -f status=running -f id=$1)" ]; then
        if [[ "$2" =~ (-c|--console) ]]; then
            shell="sh"
            if docker exec -i $1 sh -c '[ -x /bin/bash ]'; then
                shell="bash"
            fi
            docker exec -it $1 /bin/$shell
            echo -e "${red}EXIT ${tp}: ${blue}$1" 
            return 0
        else
            echo -e "${green}Already Running ${tp}: ${blue}$1${tp} $(docker ps | grep $1 | awk '{print $1}')"
            return 0
        fi
    else
        if [[ "$2" =~ (-c|--console) ]]; then
            docker start -i $1
            # when client exit the terminal, container is closing automatically
            echo -e "${red}EXIT ${tp}: ${blue}$1" 
            return 0
        else
            docker start $1
            if [ "$(docker ps -aq -f status=running -f name=$1)" ] || [ "$(docker ps -aq -f status=running -f id=$1)" ]; then
                echo -e "${green}RUNNING ${tp}: ${blue}$1${tp} $(docker ps | grep $1 | awk '{print $1}')"
            fi
            return 0
        fi
    fi
}



