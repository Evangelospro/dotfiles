ataka_completion() {
    eval $(env _TYPER_COMPLETE_ARGS="${words[1,$CURRENT]}" _PYTHON _M ATAKA_COMPLETE=complete_zsh python -m ataka)
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

function r {
if [ -z "$1" ]; then
    echo "Usage: r <path/file_name>"
else
    # run each file with its supported program
    for n in "$@"
        do
            shebang=$(head -n 1 "$n")
            case "$shebang" in
                "#!"*)
                    # get the interpreter from the shebang by replacing the shebang characters
                    interpreter=$(echo "$shebang" | sed 's/^#!//')
                    # run the file with the interpreter
                    "$interpreter" "$n"
                    ;;
                *)
                    # run the file with the default program
                    xdg-open "$n"
                    ;;
            esac
        done
fi
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