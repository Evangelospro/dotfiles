get-seclists-dir() {
    local dir
    if [ -d "/opt/seclists" ]; then
        dir="/opt/seclists"
    elif [ -d "/usr/share/seclists" ]; then
        dir="/usr/share/seclists"
    elif [ -n "$SECLISTS_PATH" ]; then
        dir="$SECLISTS_PATH"
    else
        echo "Error: Could not find SecLists directory. Please set SECLISTS_PATH environment variable or install SecLists in a standard location." >&2
        return 1
    fi
    echo $dir
    return 0
}

extraWordlistDiscovery="$HOME/.config/burp/wordlists/extraWordlistDiscovery.txt"
function get-wordlist() {
    defaultDirWordlist="/usr/share/seclists/Discovery/Web-Content/directory-list-lowercase-2.3-medium.txt"
    defaultDnsWordlist="/usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt"
    modifiedWordlistBaseName="/tmp/modifiedWordlist"
    randomSuffix=$(date +%s | sha256sum | base64 | head -c 6)
    if [[ $1 == "dir" ]]; then
        modifiedWordlist="$modifiedWordlistBaseName-dir-$randomSuffix.txt"
        /usr/bin/cp $extraWordlistDiscovery $modifiedWordlist >/dev/null 2>&1
        cat $defaultDirWordlist >>$modifiedWordlist
        echo $modifiedWordlist
    elif [[ $1 == "dns" ]]; then
        modifiedWordlist="$modifiedWordlistBaseName-dns-$randomSuffix.txt"
        /usr/bin/cp $defaultDnsWordlist $modifiedWordlist >/dev/null 2>&1
        echo $modifiedWordlist
    else
        echo "Usage: $0 <dir|dns>"
    fi
}
