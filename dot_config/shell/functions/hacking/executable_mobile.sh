## Android
function frida-init() {
    if [[ -z $1 ]]; then
        device=$(adb devices | tail -n +2 | cut -f1)
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

function frida-kill() {
    adb shell 'killall frida-server'
}
