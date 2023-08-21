
function cert(){
    cert_dir=$1
    if [ -z "$cert_dir" ]; then
        echo "Usage: $0 cert <cert_dir>"
        return
    fi
    cert_name=$(basename $cert_dir)
    openssl x509 -inform der -in $cert_dir -out /tmp/$cert_name.pem
    new_cert_name=$(openssl x509 -inform PEM -subject_hash_old -in /tmp/$cert_name.pem | head -1).0
    mv /tmp/$cert_name.pem /tmp/$new_cert_name
    adb root
    adb remount
    adb push /tmp/$new_cert_name /system/etc/security/cacerts/
    adb shell chmod 644 /system/etc/security/cacerts/$new_cert_name
    adb shell reboot
    echo "Certificate installed successfully"
}

start() {
	adb shell settings put global http_proxy localhost:8081
	adb reverse tcp:8081 tcp:8080
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
