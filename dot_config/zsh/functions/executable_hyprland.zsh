function Hyprland() {
    # if running in a tty ensure that Hyprland replaces the current shell
    # Check if nvidia-smi returns a 0 status code and if so run Hyprland with the nvidia runtime unless igpu is given as a second argument
    # mkdir -p /tmp/hypr
    # touch /tmp/hypr/extraEnv.conf
    # if [[ -z $2 ]]; then
    #     nvidia-smi > /dev/null 2>&1
    #     if [[ $? -eq 0 ]]; then
    #         echo "Nvidia GPU detected, running Hyprland with nvidia runtime"
    #         cp $HOME/.config/hypr/nvidia.conf /tmp/hypr/extraEnv.conf
    #     else
    #         echo "No Nvidia GPU detected, running Hyprland with igpu runtime"
    #     fi
    # elif [[ $2 == "igpu" ]]; then
    #     echo "Running Hyprland with igpu runtime (explicitly specified)"
    #     # remove second argument so that it doesn't get passed to Hyprland
    #     shift
    # fi
    # else
    # LOAD ENV
    # go from A=B to env A,B
    if [[ -t 0 ]]; then
        exec $HOME/.config/hypr/start "$@"
    else
        $HOME/.config/hypr/start "$@"
    fi
    # fi
}

function Hyprland-logs() {
    # # check that we are in interactive mode
    # if [[ $- == *i* ]]; then
    #     echo "You are in interactive mode, please run this command in a non-interactive shell"
    #     return 1
    # fi
    log_location=$(\ls -dt /tmp/hypr/*/ | head -n 1)
    if [[ -z $log_location ]]; then
        echo "No logs found is hyprland running?"
        return 1
    else
        tail -f $log_location/hyprland.log
    fi
}
