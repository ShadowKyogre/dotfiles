function fftrim
	set path_ext (splitext "$argv[1]")
	set path_no_ext (basename "$argv[1]" "$path_ext")
	set path_dir (dirname "$argv[1]")
	set trimmed_path "$path_dir/$path_no_ext.trimmed.$path_ext"

	ffmpeg -i "$argv[1]" -ss "$argv[2]" -t "$argv[3]" "$trimmed_path"
end
