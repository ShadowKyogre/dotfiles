function implode
	if test (count $argv) -ge 2
		set finished ""
		for arg in $argv[1..-2]
			if test $arg  = $argv[-2]
				break
			end
			set finished (printf "%s%s%s" $finished $arg $argv[-1])
		end
		set finished (printf "%s%s" $finished $argv[-2])
		echo $finished
	end
end
