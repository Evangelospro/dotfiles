if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    if [ -f "$HOME/.config/systemd/user/hyprland-session.service" ]; then
        systemctl --user start --wait hyprland-session
    else
        echo "Error: Hyprland start service not found"
    fi
fi
