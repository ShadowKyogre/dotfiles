function fish_prompt
	printf " %s_____/[%s" (set_color 5F00AF) (set_color red)
	printf "%s@%s" $USER (hostname)
	printf "%s|%s%s" (set_color 5F00AF) (set_color red) (date "+%F %T")
	printf "%s]\______________)\n(_/[%s%s" (set_color 5F00AF) (set_color red) (prompt_pwd)
	printf '%s]\_____________/(%s' (set_color 5F00AF) (set_color red)
	if test -d .git
		printf "(%s%s%s)" (set_color yellow) (git rev-parse --abbrev-ref HEAD) (set_color red)
	else
		printf "(%s\$%s)" (set_color yellow) (set_color red)
	end
	printf "%s>%s--< %s" (set_color 5F00AF) (set_color red) (set_color normal)
end

#alias completions
complete -c pkgin -xa "(pacman -Sl | cut --delim ' ' --fields 2- | tr ' ' \t)"
complete -c pkgs -xa "(pacman -Sl | cut --delim ' ' --fields 2- | tr ' ' \t)"
complete -c pkgq -xa "(pacman -Sl | cut --delim ' ' --fields 2- | tr ' ' \t)"
complete -c pkgu -xa "(pacman -Sl | cut --delim ' ' --fields 2- | tr ' ' \t)"
complete -c getpkg -xa "(pacman -Sl | cut --delim ' ' --fields 2- | tr ' ' \t)"
complete -c lpkgin -xa '(__fish_complete_suffix pkg.tar.gz)'
complete -c pkgi -xa "(pacman -Q | tr ' ' \t)"
complete -c lspkg -xa "(pacman -Q | tr ' ' \t)"
complete -c rmpkg -xa "(pacman -Q | tr ' ' \t)"
complete -c rmpkgr -xa "(pacman -Q | tr ' ' \t)"
complete -c pkgis -xa "(pacman -Q | tr ' ' \t)"
complete -c burp -s c -l category -xa "(burp -c f 2>&1|tail -n+3|sed 's/\t//g')"
complete -c burp -xa '(__fish_complete_suffix src.tar.gz)'

#other completions
complete -c qpdfview -xa '(__fish_complete_suffix pdf)'
complete -c lowriter -xa '(__fish_complete_suffix odt)'
complete -c localc -xa '(__fish_complete_suffix ods)'
