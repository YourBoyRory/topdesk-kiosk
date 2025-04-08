#!/bin/bash

waitFor() {
    echo -en "[ \033[93mWAIT\033[39m ] Waiting for $1 to load"
    waitCount=0
    while [[ "$(xdotool getwindowfocus getwindowname)" != "$1" ]]; do
        if [[ $waitCount -lt 30 ]]; then
            waitCount=$(($waitCount+1))
            sleep 1
        else
            echo -e "\r\033[K[ \033[91mFAIL\033[39m ] Waiting for $1 to load"
            restart
            waitCount=0
        fi
    done
    echo -e "\r\033[K[  \033[92mOK\033[39m  ] Waiting for $1 to load"
    sleep 1
}

restart() {
    if [[ "$(xdotool getwindowfocus getwindowname)" == "Restore Session — Mozilla Firefox" ]]; then
	press "Return"
    else
    	wmctrl -c firefox
    	sleep .5
    	pkill -f firefox # Fail safe, will resault in a error but will get cleared later
    	((run++))
    	~/.local/share/kiosk.sh 2 $run
    	exit
   fi
}

press() {
    xdotool key "$1"
    echo "	$1"
    sleep .5
}

stroke() {
    echo "	$1+$2"
    xdotool keydown "$1" key "$2" keyup "$1"
    sleep .5
}

openBoard() {
	
	stroke "Alt" "2"
	stroke "Alt" "1"
}
