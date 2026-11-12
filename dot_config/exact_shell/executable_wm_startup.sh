# uwsm check is slow (~90ms), so only ask it on a real login, not in every terminal
if [[ -z $WAYLAND_DISPLAY && -z $DISPLAY && -o login ]] && uwsm check may-start 1>/dev/null && uwsm select; then
    exec systemd-cat -t uwsm_start uwsm start default
fi
