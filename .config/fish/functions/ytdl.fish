function ytdl
	
	if test \( (count $argv) -ge 2 \) -a \( $argv[1] = audio \)
		echo youtube-dl -x --audio-format mp3 $argv[-1..2]
	else
		echo youtube-dl -f mp4 $argv
	end
end
