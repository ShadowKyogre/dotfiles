function fish_git_settings
	set -g __fish_git_prompt_showdirtystate 'yes'
	set -g __fish_git_prompt_showstashstate 'yes'
	set -g __fish_git_prompt_showupstream verbose
	set -g __fish_git_prompt_show_informative_status 'yes'
	set -g __fish_git_prompt_showuntrackedfiles 'yes'
	set -g __fish_git_prompt_char_upstream_behind '<'
	set -g __fish_git_prompt_char_upstream_ahead '>'


	set -g __fish_git_prompt_color purple
	set -g __fish_git_prompt_color_branch yellow -o
	set -g __fish_git_prompt_color_upstream blue -o
	set -g __fish_git_prompt_color_stateseparator blue
	set -g __fish_git_prompt_color_stashstate cyan
	set -g __fish_git_prompt_color_dirtystate yellow
	set -g __fish_git_prompt_color_stagedstate green
	set -g __fish_git_prompt_color_cleanstate green
end
