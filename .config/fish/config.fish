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
