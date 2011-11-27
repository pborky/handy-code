#!/bin/bash
#
# Stupid script for setup my favourite screen layout after dock, 
# or even connect the projector. 
#

out0="LVDS1"
mode0="1024x768"
out1="DVI1"
mode1="1920x1080"

if [ $# -eq 0 -o $# -gt 3 ]; then
    echo "Usage: `basename $0` (start|stop) [output  [mode]]"
    echo "Default output is $out1 and mode is $mode1."
    echo "Following outputs and modes are present:"
    xrandr
    exit
fi

if [ $# -eq 2 ]; then
    out1="$2"
fi

if [ $# -eq 3 ]; then
    mode1="$3"
fi

case "$1" in 
start|star|sta)
    xrandr  --output $out1 --mode $mode1  --output $out0 --mode $mode0 --below $out1
    ;;
stop|sto)
    xrandr --output $out0 --auto  --output $out1 --off
    ;;
esac
