function scan() {
    rustscan --ulimit 5000 -b 3000 -a $1 -- -sC -sV
}

function myip ()
{
	# Internal IP Lookup.
	if [ -e /sbin/ip ]; then
		echo -n "Internal IP: "
		/sbin/ip addr show wlan0 | grep "inet " | awk -F: '{print $1}' | awk '{print $2}'
	else
		echo -n "Internal IP: "
		/sbin/ifconfig wlan0 | grep "inet " | awk -F: '{print $1} |' | awk '{print $2}'
	fi

	# External IP Lookup
	echo -n "External IP: "
	curl -s ifconfig.me
}

function vpn() {
    VPNS_DIR="$HOME/HACKING/VPNs"
    # use fzf to filter all .ovpn files in the VPNS_DIR and connect to the selected VPN
    # if no VPN is selected, return
    # remove the VPNS_DIR prefix from the selection menu and then add it back to the selected file
    local vpn_filename
    vpn_filename=$(find "$VPNS_DIR" -type f -name "*.ovpn" | sed "s|$VPNS_DIR/||" | fzf)
    if [ -z "$vpn_filename" ]; then
        echo "No VPN selected"
        return
    fi
    # copy to /tmp/ to avoid permission issues
    /usr/bin/cp "$VPNS_DIR/$vpn_filename" "/tmp/$vpn_filename"
    sudo openvpn --config "/tmp/$vpn_filename"
}
