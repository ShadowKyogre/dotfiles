function splitext
	set fname (basename "$argv[1]")
	if expr "$fname" : '\.' > /dev/null
		set fname (expr "$fname" : "\.\(.*\)" )
	end
	echo "$fname"|grep -Eo '\.[^.]+$'
end
