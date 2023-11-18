function pwnenv() {
    if [ $(checkContainerRunning "pwnenv") ]; then
        echo "Container already running, attaching..."
        docker exec -it pwnenv zsh
    else
        echo "Starting container..."
        docker run --net=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --rm -it -v "$(pwd)":/root/data --name pwnenv ghcr.io/evangelospro/pwnenv:latest
    fi
}

function angr() {
    docker run --rm -it -v "$(pwd)":/home/angr/work --privileged --cap-add=SYS_PTRACE angrpypy
}

# windows strings utf16-le
function wstrings() {
    strings -el $1
}

function extract-base64-string(){
    /usr/bin/rg -o '^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{4})$?' $@
}

function extract-urls(){
    /usr/bin/rg -o 'https?://[^ ]+' $@
}

function extract-ips(){
    /usr/bin/rg -o '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' $@
}

## Android
function frida-init(){
    if [[ -z $1 ]]; then
        device=$(adb devices|tail -n +2 | cut -f1)
        # if the device is not an emulator connect via tcp
        if [[ $device == *emulator* ]]; then
            echo "Device is an emulator, no need to connect via tcp"
        else
            echo "Device is not an emulator, connecting via tcp"
            adb connect $device
        fi
    else
        device=$1
        adb connect $device
    fi
    # cleanup old frida-server at /tmp/frida*
    if [[ -f /tmp/frida* ]]; then
        rm /tmp/frida*
    fi
    adb root
    adb remount
    frida_version=$(frida --version)
    arch=$(adb shell getprop ro.product.cpu.abi)
    wget --show-progress -q "https://github.com/frida/frida/releases/download/$frida_version/frida-server-$frida_version-android-$arch.xz" -O /tmp/frida-server.xz
    unxz /tmp/frida-server.xz
    # disable this usap feature, it causes issues with frida
    adb shell setprop persist.device_config.runtime_native.usap_pool_enabled false
    adb push -p /tmp/frida-server /data/local/tmp/
    adb shell 'chmod 755 /data/local/tmp/frida-server'
    # kill any running frida-server
    adb shell 'killall frida-server'
    adb shell '/data/local/tmp/frida-server -D'
}

function frida-kill(){
    adb shell 'killall frida-server'
}

extraWordlist="$HOME/.config/Burp/extraWordlist.txt"
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

function scan() {
    rustscan --ulimit 5000 -b 3000 -a $1 -- -sC -sV
}

function urlencode() {
    python3 -c "from pwn import *; print(urlencode('$1'));"
}

function urldecode() {
    python3 -c "from pwn import *; print(urldecode('$1'));"
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
    ffuf -c -H "Host: FUZZ.$1" -u http://$1 -w $wordlist ${@: $arg_count};
}

ferox-dir() {
    arg_count=3
    if [[ $2 && $2 != -* ]]; then
        wordlist=$2
    else
        wordlist=$(getWordlist dir)
        arg_count=2
    fi
    feroxbuster -u $1 -w $wordlist ${@: $arg_count};
}

ffuf-dir() {
    arg_count=3
    if [[ $2 && $2 != -* ]]; then
        wordlist=$2
    else
        wordlist=$(getWordlist dir)
        arg_count=2
    fi
    ffuf -c -u $1FUZZ -w $wordlist ${@: $arg_count};
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
    ffuf -c -u $1FUZZ -w $wordlist ${@: $arg_count} -x ${exts[@]};
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
    feroxbuster -u $1 -w $wordlist -x ${exts[@]} ${@: $arg_count};
}

ffuf-req-dir() {
    arg_count=3
    if [[ $2 && $2 != -* ]]; then
        wordlist=$2
    else
        wordlist=$(getWordlist dir)
        arg_count=2
    fi
    ffuf -c -ic -request $1 -request-proto http -w $wordlist ${@: $arg_count};
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
    ffuf -c -ic -request $1 -request-proto http -w $wordlist -x ${exts[@]} ${@: $arg_count};
}

listener() {
    if [[ $1 ]]; then
        port=$1
    else
        port=1337
    fi
    stty raw -echo; (echo export TERM=xterm;echo 'python3 -c "import pty;pty.spawn(\"/bin/bash\")" || python -c "import pty;pty.spawn(\"/bin/bash\")"' ;echo "stty$(stty -a | awk -F ';' '{print $2 $3}' | head -n 1)"; echo reset;cat) | nc -lvnp $port && reset
}

# sshp username password host extr_args
sshp() {
    echo "Using sshpass to ssh into $3 as $1 with password $2 and extra args ${@: 4}"
    sshpass -p $2 ssh -o StrictHostKeyChecking=no $1@$3 ${@: 4};
}
