#!/usr/bin/env bash
set -e

source $HOME/.config/burp/scripts/env.sh

function cert() {
    cert_dir=$1
    if [ -z "$cert_dir" ]; then
        echo "Usage: $0 cert <cert_dir>"
        return
    fi
    cert_name=$(basename $cert_dir)
    openssl x509 -inform der -in $cert_dir -out /tmp/$cert_name.pem
    # needed for old method
    new_cert_name=$(openssl x509 -inform PEM -subject_hash_old -in /tmp/$cert_name.pem | head -1).0
    adb root
    adb remount
    adb push /tmp/$cert_name.pem /sdcard/Download/$cert_name.pem
    echo "Certificate pushed successfully"
    echo "Android Settings -> Security -> Encryption & Credentials -> Install a certificate -> Choose CA Certificate"
}

start() {
    # if the directory does not exist, create it
    if [ ! -d "/var/lib/waydroid/overlay/system/etc/security/cacerts/" ]; then
        sudo mkdir -p /var/lib/waydroid/overlay/system/etc/security/cacerts/
    fi
    cert_name=$(openssl x509 -inform PEM -subject_hash_old -in $BURP_CERTIFICATE_DIR/cert.pem | head -1).0
    sudo cp $BURP_CERTIFICATE_DIR/cert.pem /var/lib/waydroid/overlay/system/etc/security/cacerts/$cert_name
    sudo chmod 644 /var/lib/waydroid/overlay/system/etc/security/cacerts/$cert_name
    echo "Proxying through $BURP_IP:$BURP_PORT"
    adb shell settings put global http_proxy "192.168.240.1:$BURP_PORT"
    # adb reverse tcp:3333 tcp:$BURP_PORT
    echo "proxy started"
}

stop() {
    adb shell settings put global http_proxy :0
    adb reverse --remove-all
    echo "proxy stopped"
}

case $1 in
"start")
    start
    ;;
"stop")
    stop
    ;;
"cert")
    cert $2
    ;;
*)
    echo "Usage: $0 start|stop|cert"
    ;;
esac
