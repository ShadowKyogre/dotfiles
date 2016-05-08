function ls --description 'List contents of directory'
	set -l param --color=auto -X
		if isatty 1
			set param $param --indicator-style=classify --human-readable -s
		end
		command ls $param $argv
end
