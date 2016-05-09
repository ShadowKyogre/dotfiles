function vimhtml
	
	for arg in $argv
		if test -f "$arg"
			gvim +'let html_use_css=1 | set foldmethod=manual | colorscheme solarized | set background=light | syn on | run! syntax/2html.vim | wq | q' "$arg"
		end
	end
end
