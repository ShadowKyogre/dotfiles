function vim
	if test \( $TERM = xterm \)
		command env TERM=xterm-256color vim $argv
	else
		command vim $argv
	end
end
