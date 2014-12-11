function test_mic_sys_rec
	ffmpeg -f alsa -ac 2 -i "mic" -f alsa -ac 2 -i "mout" -filter_complex amix=inputs=2 -acodec libmp3lame -ab 128k -ar 44100 -threads 0 $argv; 
end
