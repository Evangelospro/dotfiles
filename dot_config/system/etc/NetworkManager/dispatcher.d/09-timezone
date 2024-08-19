#!/bin/sh
case "$2" in
    connectivity-change)
        timedatectl set-timezone "$(curl --fail https://ipapi.co/timezone)"
    ;;
esac
