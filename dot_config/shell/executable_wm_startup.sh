if uwsm check may-start 1>/dev/null && uwsm select; then
    exec systemd-cat -t uwsm_start uwsm start default
fi
