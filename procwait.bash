#!/bin/bash

if ([ -z "$1" ] || [ "$1" == "-h" ]); then
	sname=$(basename $0)
	echo "Usage: $sname <process-name-to-await-completion>"
	exit 0
fi

(! pgrep $1 >/dev/null) && echo "$1: No such process!" && exit 0

bg_pwait ()
{
	began_at=`date +%s`
	echo "Going to wait in the background.."
	pwait $(pgrep $1)
	lapse=$(($(date +%s) - $began_at))
	zenity --info --text="$1 completed!\nWait time: $lapse seconds" &
	paplay /usr/share/sounds/freedesktop/stereo/phone-incoming-call.oga
}

bg_pwait $1 &

exit 0
