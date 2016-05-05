function repeat_str
	set -l repeat_res ""
	for i in (seq 1 "$argv[1]")
		set repeat_res "$repeat_res$argv[2]"
	end
	printf '%s' "$repeat_res"
end
