function newls
	if test (count $argv) -gt 0
		find {$HOME,/run/media/$USER/KINGSTON}/{skart,School,Dropbox} \( ! -regex '.*/\..*' \) -type f -mmin -(math 1440 \* $argv[1])
	else
		find {$HOME,/run/media/$USER/KINGSTON}/{skart,School,Dropbox} \( ! -regex '.*/\..*' \) -type f -mmin -(math 1440 \* 1)
	end
end
