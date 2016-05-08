function ytdl
	
	if test \( (count $argv) -ge 2 \) -a \( $argv[1] = audio \)
		youtube-dl -x --audio-format mp3 $argv[2..-1]
	else
		youtube-dl -f mp4 $argv
	end
end
