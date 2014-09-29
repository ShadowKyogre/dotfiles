function saneperms
	find . -type f -exec chmod a-x -v {} \; $argv; 
end
