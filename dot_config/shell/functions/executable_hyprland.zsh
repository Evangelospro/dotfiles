function hyprland-logs() {
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
