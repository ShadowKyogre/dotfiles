function countdown
	set time_stuff (explode $argv[1] :)

	if test (count $time_stuff) -eq 0
		printf "%sDon't have all the time vars set!%s" (set_color -o red) (set_color normal)>&2
		return 1
	else if test (count $time_stuff) -eq 1
		set secs $time_stuff[1]
	else if test (count $time_stuff) -eq 2
		set secs (math $time_stuff[1] \* 60 + $time_stuff[2] )
	else
		set secs (math $time_stuff[1] \* 3600 + $time_stuff[2] \* 60 + $time_stuff[3] )
	end

	if test (count $argv) -eq 2
		vlc --qt-start-minimized --qt-notification=0 --qt-minimal-view $argv[2] >/dev/null ^/dev/null &
	end

	while test $secs -gt 0
		printf "\r%02d:%02d:%02d" (math $secs / 3600) (math \($secs / 60\) \% 60) (math $secs \% 60)
		set secs (math $secs - 1)
		sleep 1
	end

	#jobs
	#echo %1 (pidof smplayer)
	if test (count $argv) -eq 2
		kill -s SIGTERM %2
	end

	printf "\r%02d:%02d:%02d" (math $secs / 3600) (math \($secs / 60\) \% 60) (math $secs \% 60)
	ffplay -autoexit $ALARM_SOUND -nodisp -hide_banner
end
