# REBOS
function rebuild(){
    rebos gen current build
}

function rebuild-clean(){
    echo "Removing ~/.local/state/rebos"
    rm -rf ~/.local/state/rebos
    rebos setup
    rebuild
}

function recommit(){
    if [ -z "$1" ]; then
        rebos gen commit "$(date +'%Y-%m-%d %H:%M:%S')"
        return
    fi
    rebos gen commit $@
}
