#set tcl

bind-key A tcl {
	set cur_vol  [exec ponymix get-volume]

	choose-from-list \
		-tag set-volume -val "volume: $cur_vol" \
		toggle \
		increase \
		decrease \
	-selected-idx 1 \
	-onselect {
		if { "$_" eq "increase" || "$_" eq "decrease" } {
			command-prompt -p "$_" -I 10 "run-shell \"ponymix $_ %1 > /dev/null\""
		} elseif { "$_" eq "set-volume" } {
			command-prompt -p "$_" -I $cur_vol "run-shell \"ponymix $_ %1 > /dev/null\""
		} else {
			exec ponymix "$_" > /dev/null
		}
	}
}

bind-key a tcl {
	set cur_repeat [exec sh -c "cmus-remote -Q|grep repeat_current|cut -d' ' -f3"]
	set cur_status [exec sh -c "cmus-remote -Q|grep status|cut -d' ' -f2"]

	choose-from-list \
		-tag "play/pause"     -val "play/pause ($cur_status)" \
		-tag "repeat current" -val "repeat current ($cur_repeat)" \
		next \
		prev \
	-selected-idx 0 \
	-onselect {
		switch "$_" {
			"play/pause" {
				exec cmus-remote -u
			}
			"next" {
				exec cmus-remote -n
			}
			"prev" {
				exec cmus-remote -r
			}
			"repeat current" {
				exec cmus-remote --raw "toggle repeat_current"
			}
		}
	}
}

bind-key C tcl {
	choose-from-list \
	-val "<<new>>" \
	-val "<<new w/a pwd>>" \
	-val "<<attach w/a pwd>>" \
	-list [output-of-list { list-sessions -F "#S" } ] \
	-onselect {
		if { "$_" eq "<<new>>" } {
			command-prompt -p "new-session name" "new-session -A -s %1"
		} elseif { "$_" eq "<<new w/a pwd>>" } {
			command-prompt -p "new-session name,new-session pwd" -I,~ "new-session -A -s %1 -c %2"
		} elseif { "$_" eq "<<attach w/a pwd>>" } {
			command-prompt -p "session pwd" -I~ "attach-session -t %1 -c %2"
		} else {
			attach-session -t "$_"
		}
	}
}
