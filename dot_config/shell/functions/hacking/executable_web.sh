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

extraWordlistDiscovery="$HOME/.config/burp/wordlists/extraWordlistDiscovery.txt"
function getWordlist() {
    defaultDirWordlist="/usr/share/seclists/Discovery/Web-Content/directory-list-lowercase-2.3-medium.txt"
    defaultDnsWordlist="/usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt"
    modifiedWordlistBaseName="/tmp/modifiedWordlist"
    randomSuffix=$(date +%s | sha256sum | base64 | head -c 6)
    if [[ $1 == "dir" ]]; then
        modifiedWordlist="$modifiedWordlistBaseName-dir-$randomSuffix.txt"
        cp $extraWordlistDiscovery $modifiedWordlist >/dev/null 2>&1
        cat $defaultDirWordlist >> $modifiedWordlist
        echo $modifiedWordlist
    elif [[ $1 == "dns" ]]; then
        modifiedWordlist="$modifiedWordlistBaseName-dns-$randomSuffix.txt"
        cp $defaultDnsWordlist $modifiedWordlist >/dev/null  2>&1
        echo $modifiedWordlist
    else
        echo "Usage: getWordlist <dir|dns>"
    fi
}

function curl() {
    # check if the burp proxy is running and if so use it
    # see https://github.com/rs/curlie/issues/31, until this is fixed I need to use curl and not curlie...
    if [[ $(ss -lnt | grep :$BURP_PORT) ]]; then
        http_proxy="http://$BURP_IP:$BURP_PORT" https_proxy="http://$BURP_IP:$BURP_PORT" /usr/bin/curl -k "$@"
    else
        curlie --pretty "$@"
    fi
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

ffuf-vhost() {
    arg_count=3
    if [[ $2 && $2 != -* ]]; then
        wordlist=$2
    else
        wordlist=$(getWordlist dns)
        arg_count=2
    fi
    # remove the protocol http:// or https:// and any trailing slashes
    host=$(echo $1 | sed 's/http[s]*:\/\///g' | sed 's/\/$//g')
    ffuf -c -H "Host: FUZZ.$host" -u $1 -w $wordlist ${@:$arg_count}
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
