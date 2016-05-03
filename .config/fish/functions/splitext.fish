function splitext
	set fname (basename "$argv[1]")
	if expr "$fname" : '\.' > /dev/null
		echo "$fname"|cut -d'.' -f3-
	else
		echo "$fname"|cut -d'.' -f2-
	end
end
