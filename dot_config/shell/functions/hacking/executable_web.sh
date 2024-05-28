function enable-proxy-system() {
    source $HOME/.config/burp/scripts/env.sh
    openssl x509 -inform der -in "$BURP_CERTIFICATE_DIR/cert.der" -out "$BURP_CERTIFICATE_DIR/cert.pem"
    export REQUESTS_CA_BUNDLE="$BURP_CERTIFICATE_DIR/cert.pem"
    export SSL_CERT_FILE="$BURP_CERTIFICATE_DIR/cert.pem"
    export HTTP_PROXY="http://$BURP_IP:$BURP_PORT"
    export HTTPS_PROXY="http://$BURP_IP:$BURP_PORT"
    echo "Proxy enabled"
}

function disable-proxy-system() {
    unset REQUESTS_CA_BUNDLE
    unset HTTP_PROXY
    unset HTTPS_PROXY
    echo "Proxy disabled"
}

function enable-proxy-mobile() {
    $HOME/.config/burp/scripts/mobile-proxy.sh start
}

function disable-proxy-mobile() {
    $HOME/.config/burp/scripts/mobile-proxy.sh stop
}


function urlencode() {
    python3 -c "from pwn import *; print(urlencode('$1'));"
}

function urldecode() {
    python3 -c "from pwn import *; print(urldecode('$1'));"
}

extraWordlist="$HOME/.config/burp/wordlists/extraWordlist.txt"
function getWordlist() {
    # because seclists gets updated a lot and I really want .git to be in my preferred wordlist
    defaultDirWordlist="/usr/share/seclists/Discovery/Web-Content/directory-list-lowercase-2.3-medium.txt"
    defaultDnsWordlist="/usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt"
    modifiedWordlist="/tmp/modifiedWordlist.txt"
    if [[ $1 == "dir" ]]; then
        cp $extraWordlist $modifiedWordlist
        cat $defaultDirWordlist >> $modifiedWordlist
        echo $modifiedWordlist
    elif [[ $1 == "dns" ]]; then
        cp $defaultDnsWordlist $modifiedWordlist
        echo $modifiedWordlist
    else
        echo "Usage: getWordlist <dir|dns>"
    fi
}

## Web
function curl() {
    # check if the burp proxy is running and if so use it
    # see https://github.com/rs/curlie/issues/31, until this is fixed I need to use curl and not curlie...
    if [[ $(ss -lnt | grep :9000) ]]; then
        http_proxy="http://localhost:9000" https_proxy="http://localhost:9000" /usr/bin/curl -k "$@"
    else
        curlie --pretty "$@"
    fi
}

ffuf-vhost() {
    arg_count=3
    if [[ $2 && $2 != -* ]]; then
        wordlist=$2
    else
        wordlist=$(getWordlist dns)
        arg_count=2
    fi
    ffuf -c -H "Host: FUZZ.$1" -u http://$1 -w $wordlist ${@:$arg_count}
}

ferox-dir() {
    arg_count=3
    if [[ $2 && $2 != -* ]]; then
        wordlist=$2
    else
        wordlist=$(getWordlist dir)
        arg_count=2
    fi
    feroxbuster -u $1 -w $wordlist ${@:$arg_count}
}

ffuf-dir() {
    arg_count=3
    if [[ $2 && $2 != -* ]]; then
        wordlist=$2
    else
        wordlist=$(getWordlist dir)
        arg_count=2
    fi
    ffuf -c -u $1FUZZ -w $wordlist ${@:$arg_count}
}

ffuf-ext() {
    exts=(php html phps asp bak)
    arg_count=3
    if [[ $2 && $2 != -* ]]; then
        wordlist=$2
    else
        wordlist=$(getWordlist dir)
        arg_count=2
    fi
    ffuf -c -u $1FUZZ -w $wordlist ${@:$arg_count} -x ${exts[@]}
}

ferox-ext() {
    exts=(php html phps asp bak)
    arg_count=3
    if [[ $2 && $2 != -* ]]; then
        wordlist=$2
    else
        wordlist=$(getWordlist dir)
        arg_count=2
    fi
    feroxbuster -u $1 -w $wordlist -x ${exts[@]} ${@:$arg_count}
}

ffuf-req-dir() {
    arg_count=3
    if [[ $2 && $2 != -* ]]; then
        wordlist=$2
    else
        wordlist=$(getWordlist dir)
        arg_count=2
    fi
    ffuf -c -ic -request $1 -request-proto http -w $wordlist ${@:$arg_count}
}

ffuf-req-ext() {
    exts=(php html phps asp bak)
    arg_count=3
    if [[ $2 && $2 != -* ]]; then
        wordlist=$2
    else
        wordlist=$(getWordlist dir)
        arg_count=2
    fi
    ffuf -c -ic -request $1 -request-proto http -w $wordlist -x ${exts[@]} ${@:$arg_count}
}
