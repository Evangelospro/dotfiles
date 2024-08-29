if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    if [ -f "$HOME/.config/systemd/user/hyprland-session.service" ]; then
        exec ~/.config/hypr/start
    else
        echo "Error: Hyprland start service not found"
    fi
fi
