function breakcycle --description 'Reinforces when to take a break'
	if set -q TMUX
		tmux rename-window breakcycle
	end

	set first_loop 1

	while true
		if set -q TMUX
			tmux set-window-option -q @bcycle-paused 0
		end
		if test \( "$first_loop" -eq 1 \) -a \( -n "$argv[1]" \)
			termdown "$argv[1]" -c 5 -a -f 3x5 -T "Computer time"
			set first_loop 0
		else
			termdown 2h -c 5 -a -f 3x5 -T "Computer time"
		end
		notify-send "Get off your seat" -t 20000
		if set -q TMUX
			tmux-notify-all.sh "Get off your seat"
		end

		if set -q TMUX
			tmux set-window-option -q @bcycle-paused 0
		end
		termdown 10m -c 5 -a -f 3x5 -T "Exercise time"
		notify-send "You can get back in seat" -t 20000
		if set -q TMUX
			tmux-notify-all.sh "You can get back in seat"
		end
	end
end
