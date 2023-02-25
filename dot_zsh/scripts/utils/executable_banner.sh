#!/bin/bash
# /usr/bin/clear
randomNum=$RANDOM
# if divisible by 2
if [ $((randomNum % 2)) -eq 0 ]; then
    neofetch| lolcat
else
    figlet -w 300 -f Bloody Evangelospro | lolcat
fi