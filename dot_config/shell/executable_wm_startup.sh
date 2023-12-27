## Launches WM on session start
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec $HOME/.config/hypr/start
fi
