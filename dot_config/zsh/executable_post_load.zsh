# end profiler check that it is not already running
if [[ "${SHELL_PROFILE}" == 1 ]]; then
    zprof
    echo "Stopping profiler"
    exit
fi
