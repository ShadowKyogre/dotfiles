set tcl 1

proc volume_manager {} {
	variable cur_vol  [exec ponymix get-volume]

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



proc cmus_control {} {
	variable cur_repeat [exec sh -c "cmus-remote -Q|grep repeat_current|cut -d' ' -f3"]
	variable cur_status [exec sh -c "cmus-remote -Q|grep status|cut -d' ' -f2"]

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

proc session_manager {} {
	variable items [output-of-list { list-sessions -F "#S" }]

	choose-from-list \
	-val "<<new>>" \
	-val "<<new w/a pwd>>" \
	-val "<<attach w/a pwd>>" \
	-val "<<kill>>" \
	-list $items \
	-onselect {
		if { "$_" eq "<<new>>" } {
			command-prompt -p "new-session name" "new-session -A -s %1"
		} elseif { "$_" eq "<<new w/a pwd>>" } {
			command-prompt -p "new-session name,new-session pwd" -I,~ "new-session -A -s %1 -c \[file normalize %2\]"
		} elseif { "$_" eq "<<attach w/a pwd>>" } {
			choose-from-list -list $items \
			-onselect {
				command-prompt -p "session pwd" -I~ "attach-session -t $_ -c \[file normalize %2\]"
			}
		} elseif { "$_" eq "<<kill>>" } {
			choose-from-list -list $items \
			-onselect {
				kill-session -t "$_"
			}
		} else {
			attach-session -t "$_"
		}
	}
}

proc resizer {} {
	choose-from-list \
		"Down" \
		"Up" \
		"Right" \
		"Left" \
		-onselect {
			switch "$_" {
				"Down" {
					command-prompt -p "$_" -I 5 "resize-pane -D %1"
				}
				"Up" {
					command-prompt -p "$_" -I 5 "resize-pane -D %1"
				}
				"Left" {
					command-prompt -p "$_" -I 5 "resize-pane -L %1"
				}
				"Right" {
					command-prompt -p "$_" -I 5 "resize-pane -R %1"
				}
			}
		}
}

proc correct_theme {} {
	variable total_match ""
	variable n_colors ""
	variable term_colors [output-of-txt { server-info }]
	regexp -line "\[0-9\]+: colors: \\(number\\) (\[0-9\]+)" "$term_colors" total_match n_colors

	if { "$n_colors" eq "256" } {
		source-file .tmux-theme256.conf
	} else {
		source-file .tmux-theme16.conf
	}
}


bind-key A tcl volume_manager
bind-key a tcl cmus_control
bind-key C tcl session_manager
bind-key R tcl resizer
