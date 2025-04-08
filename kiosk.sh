#!/bin/bash

source /home/kiosk/.local/share/keystroke_lib.sh

if [[ $2 -eq 5 ]]; then
	reboot
else
	run=$2
fi
echo $run

#flatpak run com.spotify.Client

# Stage 1
xdotool mousemove 1920 1080
echo "Waiting for network"
sleep $1
(firefox -kiosk "my.topdesk.net") &
echo "Begin hotkey script"

#Stage 2
waitFor "Login — Mozilla Firefox"
press "Tab"
press "Return"

#Stage 3
waitFor "TOPdesk - Home — Mozilla Firefox"
while true; do
	if ! [ -e /tmp/kiosk_lock ]; then
		echo "kiosk" > /tmp/kiosk_lock
		if grep -q "kiosk" /tmp/kiosk_lock; then
			openBoard
			waitFor "TOPdesk - Common - New — Mozilla Firefox"
			rm /tmp/kiosk_lock
		fi
	fi
    sleep 10
done
