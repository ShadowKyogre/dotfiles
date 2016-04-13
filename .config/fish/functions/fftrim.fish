function fftrim
	set path_parts (splitext "$argv[1]")
	set trimmed_path "$path_parts[1].trimmed$path_parts[2]"
	ffmpeg -i "$argv[1]" -ss "$argv[2]" -t "$argv[3]" "$trimmed_path"
end
