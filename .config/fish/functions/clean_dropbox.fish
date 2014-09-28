function clean_dropbox
	set files (find ~/Dropbox -regextype posix-extended -regex '.*\([0-9]+\).*')	
	if test (count $files) -gt 0
		rm $files
		printf "%s%s%s" (set_color -o yellow) "Done dealing with conflicted copies" (set_color normal)
	else
		printf "%s%s%s" (set_color -o green) "No conflicted copies found!" (set_color normal)
	end
end
