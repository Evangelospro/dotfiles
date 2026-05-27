function copy() {
    # piped or file
    if [[ -t 0 ]]; then
        if [[ -z $1 ]]; then
            echo "No input provided for copy"
            return 1
        fi
        input=$(cat "$1")
    else
        input=$(cat)
    fi
    if [[ -z $WAYLAND_DISPLAY ]]; then
        echo "$input" | tr -d '\n' | xclip -selection clipboard
    else
        echo "$input" | wl-copy
    fi
}

function paste() {
    if [[ -z $WAYLAND_DISPLAY ]]; then
        xclip -selection clipboard -o
    else
        wl-paste
    fi

}
