(( $+commands[lig] )) && eval "$(lig init zsh post)" # plain eval: smartcache's err_return truncates it

# end profiler check that it is not already running
if [[ "${SHELL_PROFILE}" == 1 ]]; then
    zprof
    echo "Stopping profiler"
    exit
fi
