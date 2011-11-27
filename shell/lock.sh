#!/bin/bash
#
#            Locker script for i3wm 
# It uses i3lock and in addition it removes alt keycode.
# Then it is then dificult to switch to tty. After i3lock 
# dissapear alt is remapped to proper keycodes.
# 
# 

add="/tmp/mmadd$$.tmp"
del="/tmp/mmdel$$.tmp"

# generate scripts for add and for remove alt from keycodes
xmodmap -pke | grep -i alt | while read line; do 
    echo "$line" >> $add
    echo "$(expr "$line" : '\(keycode\s\+[0-9]\+\)\s\+.*') =" >> $del
done

# lock the screen
i3lock $@

# delete the mapping
xmodmap $del
rm $del

# should be empty
xmodmap -pke | grep -i alt

# fork this to reassign alt to keycodes after i3lock dissapear
while true; do 
    if pgrep i3lock > /dev/null; then 
        false # nop
    else 
        # do the stuff and break the loop
        xmodmap $add 
        rm $add
        # alt should be back
        xmodmap -pke | grep -i alt
        break
    fi
    sleep 1
done &

