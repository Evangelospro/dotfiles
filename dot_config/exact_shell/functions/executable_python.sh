function p() {
    if [ $# -eq 0 ]; then
        ipython
    else
        python3 "$@"
    fi

}
