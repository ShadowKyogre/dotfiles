#!/bin/bash

for num in {0..15};do
	color="$(grep "^color${num}\s\+" "${1:-${HOME}/.config/termite/config}"|grep -o "[0-9a-f]\{3,6\}$")"
	rhex="${color:0:2}"
	ghex="${color:2:2}"
	bhex="${color:4:2}"

	r="$((0x${rhex}))"
	g="$((0x${ghex}))"
	b="$((0x${bhex}))"
	echo "echo -ne \"\e[3;${num};${r};${g};${b}}\""
done
