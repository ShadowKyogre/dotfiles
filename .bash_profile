source ~/.bashrc

if ! pulseaudio --check;then
	pulseaudio --start
fi
tmux new-session -ds dropdown 2> /dev/null
