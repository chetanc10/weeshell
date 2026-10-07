#!/bin/bash

if ([ -z "$1" ] || [ "$1" == "-h" ]); then
	echo "Usage: $(basename $0) <ip-or-webDomain-to-await-till-ping-reachable>"
	exit 0
fi

bg_ping ()
{
	until ping -q -c1 -W2 $1 >/dev/null 2>&1; do
		sleep 2
	done
	zenity --info --text="$1 reachable now!" &
	paplay /usr/share/sounds/freedesktop/stereo/phone-incoming-call.oga
}

ping -q -c1 -W2 $1 >/dev/null 2>&1 && echo "$1 is reachable!" && exit 0

bg_ping $1 &

exit 0
