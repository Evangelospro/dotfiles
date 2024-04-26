#!/usr/bin/env bash

battery() {
    BAT=$(\ls /sys/class/power_supply | grep BAT | head -n 1)
    if [ -z $BAT ]; then
        case $1 in
        --percent) echo "0" ;;
        --status) echo "No battery connected" ;;
        esac
    else
        percent=$(\cat /sys/class/power_supply/${BAT}/capacity)
        status=$(\cat /sys/class/power_supply/${BAT}/status)
        case $1 in
        --percent) echo $percent ;;
        --status) echo $status ;;
        esac
    fi
}

network() {
    status=$(nmcli g | grep -oE "disconnected")

    if [ $status ]; then
        icon="睊"
        essid=""
    else
        essid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
        icon=""
    fi

    case $1 in
    --essid) echo $essid ;;
    --icon) echo $icon ;;
    esac
}

bluetooth() {
    status=$(bluetoothctl show | grep -oE "Powered: yes")
    devices=$(bluetoothctl devices | grep Device | cut -d ' ' -f 2-)

    if [ $status ]; then
        icon=""
        text=""
    else
        icon=""
        text=""
    fi

    case $1 in
    --devices) echo $devices ;;
    --icon) echo $icon ;;
    esac
}

memory() {
    total="$(free -m | grep Mem: | awk '{ print $2 }')"
    used="$(free -m | grep Mem: | awk '{ print $3 }')"
    free=$(expr $total - $used)

    case $1 in
    --total) echo $total ;;
    --used) echo $used ;;
    --free) echo $free ;;
    esac
}

brightness() {
    max=$(brightnessctl m)
    current=$(brightnessctl g)
    percent=$(echo "scale=2; $current / $max * 100" | bc)

    case $1 in
    --percent) echo $percent ;;
    esac

}

notifications() {
    dndStatus=$(swaync-client -D)
    if [[ "$dndStatus" == "true" ]]; then
        icon=""
    else
        icon=""
    fi
    notificationsNum=$(swaync-client -c)
    case $1 in
    --icon) echo $icon ;;
    --num) echo $notificationsNum ;;
    --all) echo "$icon $notificationsNum" ;;
    esac
}

sound() {
    status=$(amixer get Master | tail -n1 | grep -wo 'on')

    if [[ "$status" == "on" ]]; then
        volume=$(amixer get Master | tail -n1 | awk -F ' ' '{print $5}' | tr -d '[%]')
    else
        volume=0
    fi
    current="${volume%%%}"

    if [[ "$status" == "on" ]]; then
        if [[ "$current" -eq "0" ]]; then
            icon="ﱝ"
        elif [[ ("$current" -ge "0") && ("$current" -le "30") ]]; then
            icon="奄"
        elif [[ ("$current" -ge "30") && ("$current" -le "60") ]]; then
            icon="奔"
        elif [[ ("$current" -ge "60") && ("$current" -le "100") ]]; then
            icon="墳"
        fi
    else
        icon="ﱝ"
    fi

    case $1 in
    --icon) echo $icon ;;
    --percent) echo $volume ;;
    esac
}

# Check command-line arguments and call the appropriate function
case $1 in
"battery") battery $2 ;;
"memory") memory $2 ;;
"network") network $2 ;;
"notifications") notifications $2 ;;
"sound") sound $2 ;;
"brightness") brightness $2 ;;
esac
