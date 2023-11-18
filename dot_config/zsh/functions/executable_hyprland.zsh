function Hyprland() {
    # if running in a tty ensure that Hyprland replaces the current shell
    # Check if nvidia-smi is installed and if so run Hyprland with the nvidia runtime
    mkdir -p /tmp/hypr
    if [[ -x "$(command -v nvidia-smi)" ]]; then
        cp $HOME/.config/hypr/nvidia.conf /tmp/hypr/extraEnv.conf
    else
        touch /tmp/hypr/extraEnv.conf
    fi
    if [[ -t 0 ]]; then
        exec /usr/local/bin/Hyprland "$@"
    else
        /usr/local/bin/Hyprland "$@"
    fi
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
