function splitext
	set fname (basename "$argv[1]")
	if expr "$fname" : '\.' > /dev/null
		echo "$fname"|grep -Eo '(\.[^_.-])+$'
	else
		echo "$fname"|grep -Eo '(\.[^_.-])+$'
	end
end
