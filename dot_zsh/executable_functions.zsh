ataka_completion() {
    eval $(env _TYPER_COMPLETE_ARGS="${words[1,$CURRENT]}" _PYTHON _M ATAKA_COMPLETE=complete_zsh python -m ataka)
}

# clipboard
# X11 / Wayland
function copy() {
    if [[ -z $WAYLAND_DISPLAY ]]; then
        xclip -selection clipboard
    else
        wl-copy
    fi
}

function paste() {
    if [[ -z $WAYLAND_DISPLAY ]]; then
        xclip -selection clipboard -o
    else
        wl-paste
    fi
}

function checkContainerRunning() {
    docker container ls -q -f name="$1"
}

function pwnenv() {
    if [ $(checkContainerRunning "pwnenv") ]; then
        echo "Container already running, attaching..."
        docker exec -it pwnenv zsh
    else
        echo "Starting container..."
        docker run --net=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --rm -it pwnenv zsh
    fi
}

# An all in one extract function for all archive types
function ex {
if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: ex <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       ex <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                        tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.cbr|*.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                        7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.cpio)      cpio -id < ./"$n"  ;;
            *.cba|*.ace)      unace x ./"$n"      ;;
            *)
                        echo "ex: '$n' - unknown archive method"
                        return 1
                        ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

# colorized man pages
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;35m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[4;36m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[3;34m") \
		PAGER="${commands[less]:-$PAGER}" \
		_NROFF_U=1 \
		PATH="$HOME/bin:$PATH" \
			man "$@"
}

# navigation
up () {
local d=""
local limit="$1"

# Default to limit of 1
if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
limit=1
fi

for ((i=1;i<=limit;i++)); do
d="../$d"
done

# perform cd. Show error if cd fails
if ! cd "$d"; then
echo "Couldn't go up $limit dirs.";
fi
}

# Adding onefetch to every cd you do with a .git dir
cd () {
	__zoxide_z "$@"
	git rev-parse 2> /dev/null
	if [ $? -eq 0 ]
	then
		if [ "$LAST_REPO" != $(basename "$(git rev-parse --show-toplevel)") ]
		then
			onefetch
			LAST_REPO=$(basename "$(git rev-parse --show-toplevel)") 
		fi
	fi
}

urlencode() {
LC_ALL=C awk -- '
    BEGIN {
    for (i = 1; i <= 255; i++) hex[sprintf("%c", i)] = sprintf("%%%02X", i)
    }
    function urlencode(s,  c,i,r,l) {
    l = length(s)
    for (i = 1; i <= l; i++) {
        c = substr(s, i, 1)
        r = r "" (c ~ /^[-._~0-9a-zA-Z]$/ ? c : hex[c])
    }
    return r
    }
    BEGIN {
    for (i = 1; i < ARGC; i++)
        print urlencode(ARGV[i])
    }' "$@"
}