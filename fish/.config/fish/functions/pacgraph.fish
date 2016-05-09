function pacgraph
	command pacgraph -b "#000000" -l "#8800FF" -t "#0000FF" -d "#FF0000" --svg
	convert pacgraph.svg -resize 1680x1050\^ -gravity center -extent 1680x1050 ~/Pictures/WallPaper/pacgraph.png
	rm -f ~/pacgraph.svg	
end
