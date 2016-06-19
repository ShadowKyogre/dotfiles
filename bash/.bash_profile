source ~/.bashrc

if [ "$TERM" = linux ];then
	if ! pulseaudio --check;then
		pulseaudio --start
	fi
fi
