function fish_git_settings
	set -U __fish_git_prompt_showdirtystate 'yes'
	set -U __fish_git_prompt_showstashstate 'yes'
	set -U __fish_git_prompt_showupstream verbose
	set -U __fish_git_prompt_showuntrackedfiles 'yes'
	set -U __fish_git_prompt_color_branch yellow -o
	set -U ___fish_git_prompt_char_upstream_behind '<'
	set -U ___fish_git_prompt_char_upstream_ahead '>'

	set -U ___fish_git_prompt_color_stashstate (set_color cyan)
	set -U ___fish_git_prompt_color_dirtystate (set_color yellow)
	set -U ___fish_git_prompt_color_stagedstate (set_color green)
	set -U ___fish_git_prompt_color_stashstate_done (set_color normal)
	set -U ___fish_git_prompt_color_dirtystate_done (set_color normal)
	set -U ___fish_git_prompt_color_stagedstate_done (set_color normal)
end
