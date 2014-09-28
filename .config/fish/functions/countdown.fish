function countdown
	if test (count $argv) -eq 0
		printf "%sDon't have all the time vars set!%s" (set_color -o red) (set_color normal)>&2
		return 1
	else if test (count $argv) -eq 1
		set secs $argv[1]
	else if test (count $argv) -eq 2
		set secs (math $argv[1] \* 60 + $argv[2] )
	else
		set secs (math $argv[1] \* 3600 + $argv[2] \* 60 + $argv[3] )
	end
	while test $secs -gt 0
		printf "\r%02d:%02d:%02d" (math $secs / 3600) (math \($secs / 60\) \% 60) (math $secs \% 60)
		set secs (math $secs - 1)
		sleep 1
	end
	printf "\r%02d:%02d:%02d" (math $secs / 3600) (math \($secs / 60\) \% 60) (math $secs \% 60)
	ffplay -autoexit ~/Music/Bayonetta/Bayonetta_-_Lets_Dance_Boys.mp3 -ss 3 -t 71.5 -nodisp -hide_banner
end
