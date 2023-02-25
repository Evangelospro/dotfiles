from subprocess import check_output, call
prev_command = check_output('tail -n 2 ~/.zsh/zsh_history.zsh', shell=True).split(b":0;")[1].split(b":")[0].replace(b"\n", b"")
call(b"sudo " + prev_command, shell=True)