#!/bin/bash
file="$(cmus-remote -C status|head -2|tail -1|cut -d' ' -f2-)"

if [ -f "$file" ]
then
	echo "$file" >> ~/.config/cmus/.favorites
	sort -u -o ~/.config/cmus/.favorites ~/.config/cmus/.favorites
	notify-send -i "bookmark-new" -a "cmus" "File marked as quick favorite" "$file" &
fi
