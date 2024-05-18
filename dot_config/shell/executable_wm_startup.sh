if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    if [ -x "$HOME/.config/hypr/start" ]; then
        exec $HOME/.config/hypr/start
    else
        echo "Error: Hyprland start script not found."
    fi
fi
