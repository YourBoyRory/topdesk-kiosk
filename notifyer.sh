#!/bin/bash
source /home/kiosk/.local/share/keystroke_lib.sh
notify=0
echo "Message from service: Service Started"
while true; do
    dbus-monitor "interface='org.freedesktop.Notifications'" |
    while read line; do
		if echo "$line" | grep -q "Notify"; then
			echo "$line"
			#paplay $1 &
			notify=1
		elif [[ $notify -eq 1 ]]; then
			if echo "$line" | grep -q "Firefox"; then
				paplay /home/kiosk/.local/share/sound.mp3 &
				if ! [ -e /tmp/kiosk_lock ]; then
					echo "notify" > /tmp/kiosk_lock
					if grep -q "notify" /tmp/kiosk_lock; then
						openBoard
						waitFor "TOPdesk - Common - New — Mozilla Firefox"
						rm /tmp/kiosk_lock
					fi
				fi
			fi
			echo "$line"
			break
		fi
    done
done

