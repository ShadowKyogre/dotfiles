function repeat_str
	for i in (seq 1 "$argv[1]")
		printf '%s' "$argv[2]"
	end
end
