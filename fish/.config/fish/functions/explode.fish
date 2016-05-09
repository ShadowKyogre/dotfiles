function explode
	if test (count $argv) -eq 2
		echo $argv[1]|sed 's|'$argv[2]'|\n|g'
	end
end
