#!/bin/bash
# /usr/bin/clear
randomNum=$RANDOM
# if divisible by 2
if [ $((randomNum % 2)) -eq 0 ]; then
    neofetch| lolcat
else
    width=$(tput cols)
    figlet -w $width -f Bloody Evangelospro | lolcat
fi