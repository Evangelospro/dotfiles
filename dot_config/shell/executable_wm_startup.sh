if uwsm check may-start && uwsm select; then
	systemd-cat -t uwsm_start uwsm start default
fi
