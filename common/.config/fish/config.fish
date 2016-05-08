function fish_mode_prompt
end

function fish_vi_mode_display
	# Do nothing if not in vi mode
	if set -q __fish_vi_mode
		switch $fish_bind_mode
			case default
				set_color --bold --background red white
				echo -n "$argv[1]"
			case insert
				set_color --bold --background blue white
				echo -n "$argv[1]"
			case visual
				set_color --bold --background magenta white
				echo -n "$argv[1]"
		end
		set_color normal
	else
		echo -n "$argv[1]"
	end
end

function fish_prompt

	set -l _user $USER
	if set -q FAKEUSER
		set -l _user $FAKEUSER
	end

	set -l _prompt_meta (printf "%s-[%s" (set_color purple) (set_color -o red))
	set _prompt_meta (printf "%s%s" "$_prompt_meta" (fish_vi_mode_display (printf "%s@%s" $_user (hostname))))
	set _prompt_meta (printf "%s%s%s|%s%s" "$_prompt_meta" (set_color normal) (set_color purple) (set_color -o red) (date "+%F %T"))
	set _prompt_meta (printf "%s%s%s]-\\" "$_prompt_meta" (set_color normal) (set_color purple))

	set_color purple
	repeat_str (expr "$COLUMNS" - (no_ansi_wc "$_prompt_meta")) "-"
	set_color normal
	printf "%s\n" "$_prompt_meta"

	set -l _prompt_pwd (printf "%s%s-[%s%s%s%s]-/" (set_color normal) (set_color purple) (set_color -o red) (prompt_pwd) (set_color normal) (set_color purple))
	printf "%s/" (set_color purple)
	repeat_str (expr "$COLUMNS" - (no_ansi_wc "$_prompt_pwd") - 1) "-"
	printf '%s' "$_prompt_pwd"

	__fish_git_prompt '\n'(set_color -b red -o yellow)\|(set_color normal)' %s\n'(set_color normal)
	if test "$status" -ne 0
		printf "\n"
	end

	printf "%s\\-(%s(%s\$%s)" (set_color purple) (set_color red -o) (set_color yellow -o) (set_color -o red)
	printf "%s%s>%s-< %s" (set_color normal) (set_color purple) (set_color -o red) (set_color normal)
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


complete -c newf -xa "(functions -na)" --description "Create and save functions"

fish_vi_mode
fish_git_settings

eval (direnv hook fish)
