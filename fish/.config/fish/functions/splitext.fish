function splitext
	set fname (basename "$argv[1]")
	if expr "$fname" : '\.' > /dev/null
		set fname (expr "$fname" : "\.\(.*\)" )
	end
	if not expr "$fname" : ".*\..*" > /dev/null
		echo
	else
		echo "$fname"|awk -F. '{print $NF}'
	end
end
