# Runs after ghostty-integration, which defines its own ssh wrapper. Inside ghostty, +ssh runs our shim so both apply; elsewhere interactive ssh goes through lig
ssh() {
    if [[ $TERM_PROGRAM == ghostty && -n $GHOSTTY_BIN_DIR ]]; then
        local flags=()
        [[ "$GHOSTTY_SHELL_FEATURES" != *ssh-env* ]] && flags+=(--forward-env=false)
        [[ "$GHOSTTY_SHELL_FEATURES" != *ssh-terminfo* ]] && flags+=(--terminfo=false)
        "$GHOSTTY_BIN_DIR/ghostty" +ssh $flags --ssh=$XDG_CONFIG_HOME/shell/scripts/ssh-lig.sh -- "$@"
    elif (( $+commands[lig] )) && [[ -t 0 && -t 1 ]]; then
        lig ssh "$@"
    else
        command ssh "$@"
    fi
}

(( $+commands[lig] )) && eval "$(lig init zsh post)" # plain eval: smartcache's err_return truncates it

# end profiler check that it is not already running
if [[ "${SHELL_PROFILE}" == 1 ]]; then
    zprof
    echo "Stopping profiler"
    exit
fi
