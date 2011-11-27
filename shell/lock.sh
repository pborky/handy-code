#!/bin/bash
#
#            Locker script for i3wm 
# It uses i3lock and in addition it removes alt keycode.
# Then it is then dificult to switch to tty. After i3lock 
# dissapear alt is remapped to proper keycodes.
# 
# 

LOCK=/usr/local/bin/i3lock
XMM=/usr/bin/xmodmap
GREP=/bin/grep
PGREP=/usr/bin/pgrep

add="/tmp/mmadd$$.tmp"
del="/tmp/mmdel$$.tmp"

# generate scripts for add and for remove alt from keycodes
$XMM -pke | $GREP -i alt | while read line; do 
    echo "$line" >> $add
    echo "$(expr "$line" : '\(keycode\s\+[0-9]\+\)\s\+.*') =" >> $del
done

# lock the screen
$LOCK $@

# delete the mapping
$XMM $del
rm $del

# should be empty
$XMM -pke | $GREP -i alt

# fork this to reassign alt to keycodes after i3lock dissapear
while true; do 
    if $PGREP i3lock > /dev/null; then
        false # nop
    else 
        # do the stuff and break the loop
        $XMM $add 
        rm $add
        # alt should be back
        $XMM -pke | $GREP -i alt
        break
    fi
    sleep 1
done &
