## Launches WM on session start
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && ["$(stat -c %d:%i /)" = "$(stat -c %d:%i /proc/1/root.)"]; then
    exec $HOME/.config/hypr/start
fi
