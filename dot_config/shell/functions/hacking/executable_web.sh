function enable-proxy-system() {
    openssl x509 -inform der -in "$BURP_CERTIFICATE_DIR/cert.der" -out "$BURP_CERTIFICATE_DIR/cert.pem"
    export REQUESTS_CA_BUNDLE="$BURP_CERTIFICATE_DIR/cert.pem"
    export SSL_CERT_FILE="$BURP_CERTIFICATE_DIR/cert.pem"
    export HTTP_PROXY="http://$BURP_IP:$BURP_PORT"
    export http_proxy="http://$BURP_IP:$BURP_PORT"
    export HTTPS_PROXY="http://$BURP_IP:$BURP_PORT"
    export https_proxy="http://$BURP_IP:$BURP_PORT"
    echo "Proxy enabled"
}

function disable-proxy-system() {
    unset REQUESTS_CA_BUNDLE
    unset SSL_CERT_FILE
    unset HTTP_PROXY http_proxy
    unset HTTPS_PROXY https_proxy
    echo "Proxy disabled"
}

function enable-proxy-mobile() {
    $HOME/.config/burp/scripts/mobile-proxy.sh start
}

function disable-proxy-mobile() {
    $HOME/.config/burp/scripts/mobile-proxy.sh stop
}

# check if it is piped then use curl not curlie
function curl() {
    # check if the burp proxy is running and if so use it
    # see https://github.com/rs/curlie/issues/31, until this is fixed I need to use curl and not curlie...
    if [[ -n "$HTTP_PROXY" || -n "$HTTPS_PROXY" ]]; then
        /usr/bin/curl -k "$@"
    else
        if [ -t 1 ]; then
            curlie --pretty "$@"
        else
            /usr/bin/curl -s "$@"
        fi
    fi
}

EXTENSIONS=(php html phps bak)

# clean the url to have no trailing slashes
function clean_url() {
    echo $1 | sed 's/\/$//g'
}

ferox-dir() {
    url=$(clean_url $1)
    shift
    if [[ $2 && $2 != -* ]]; then
        wordlist=$2
        shift
    else
        wordlist=$(get-wordlist dir)
    fi
    feroxbuster -u $url -w $wordlist "$@"
}

ferox-ext() {
    url=$(clean_url $1)
    shift
    exts=${EXTENSIONS[@]}
    if [[ $2 && $2 != -* ]]; then
        wordlist=$2
        shift
    else
        wordlist=$(get-wordlist dir)
    fi
    feroxbuster -u $url -w $wordlist -x $exts "$@"
}

ffuf-dir() {
    url=$(clean_url $1)
    shift
    if [[ $2 && $2 != -* ]]; then
        wordlist=$2
        shift
    else
        wordlist=$(get-wordlist dir)
    fi
    ffuf -c -u $url/FUZZ -w $wordlist "$@"
}

ffuf-vhost() {
    url=$(clean_url $1)
    shift
    if [[ $2 && $2 != -* ]]; then
        wordlist=$2
        shift
    else
        wordlist=$(get-wordlist dns)
    fi
    # remove the protocol http:// or https:// and any trailing slashes
    host=$(echo $url | sed 's/http[s]*:\/\///g' | sed 's/\/$//g')
    ffuf -c -H "Host: FUZZ.$host" -u $url -w $wordlist "$@"
}

ffuf-ext() {
    url=$(clean_url $1)
    shift
    # make extensions a comma separated list with . at the beginning of each extension
    exts=$(printf ".%s," "${EXTENSIONS[@]}" | sed 's/,$//')
    if [[ $2 && $2 != -* ]]; then
        wordlist=$2
        shift
    else
        wordlist=$(get-wordlist dir)
    fi
    ffuf -c -u $url/FUZZ -w $wordlist -e $exts "$@"
}
