#!/bin/bash
file="$(cmus-remote -C 'echo {}')"

if [ -f "$file" ]
then
	kitty -T "Editing tags for ${file}" -e "${HOME}/bin/mutagen_urwid.py" "${file}" &
else
	echo "Oop, couldn't find selected track" >&2
fi
