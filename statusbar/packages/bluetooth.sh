#!/bin/bash

tempfile=$(cd $(dirname $0);cd ..;pwd)/temp

this=_bluetooth
icon_color="^c#ffffff^^b#333333^"
text_color="^c#ffffff^^b#333333^"
signal=$(echo "^s$this^" | sed 's/_//')

update() {
    icon="󰂯 "

    name=$(bluetoothctl info | grep 'Name: ' | cut -d' ' -f2-)
    level=$(bluetoothctl info | grep 'Battery Percentage' | cut -d' ' -f4-)
    text=$name$level

    sed -i '/^export '$this'=.*$/d' $tempfile
    printf "export %s='%s%s%s%s%s'\n" $this "$signal" "$icon_color" "$icon" "$text_color" "$text" >> $tempfile
}

call_bluetui() {
    pid1=`ps aux | grep 'st -t statusutil' | grep -v grep | awk '{print $2}'`
    pid2=`ps aux | grep 'st -t statusutil_mem' | grep -v grep | awk '{print $2}'`
    mx=`xdotool getmouselocation --shell | grep X= | sed 's/X=//'`
    my=`xdotool getmouselocation --shell | grep Y= | sed 's/Y=//'`
    kill $pid1 && kill $pid2 || st -t statusutil_mem -g 100x30+$((mx - 328))+$((my + 20)) -c FGN -e bluetui
}

click() {
    case "$1" in
        L) ;;
        R) call_bluetui ;;
    esac
}

case "$1" in
    click) click $2 ;; 
    notify) notify ;;
    *) update ;;
esac

