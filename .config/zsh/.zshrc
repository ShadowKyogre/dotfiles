setopt appendhistory autocd extendedglob
setopt no_complete_aliases

# completion opts
() {
	zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
	zstyle ':completion:*' menu yes select
	zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
}

# man page completions
() {
	zstyle ':completion:*:man:*' menu yes select
	zstyle ':completion:*:manuals' separate-sections true
	zstyle ':completion:*:manuals.*' insert-sections true
}

# Completion menu styling
() {
	zstyle ':completion:*:*:kill:*' list-colors '=(#b) #([0-9]#)*( *[a-z])*=34;1=31;1=33;1'
	zstyle ':completion:*:(commands|functions|aliases)' list-colors \
		'=(#b)(*)-- (*)=35;1=34;1=33;1' '=*=34;1'
	zstyle ':completion:*:(options|values)' list-colors \
		'=(#b)(*)-- (*)=35;1=31;1=33;1' '=*=31;1'
	eval "$(dircolors -b)"
	zstyle ':completion:*' list-colors "${LS_COLORS}"
}

# file completion in middle
() {
	zstyle ':completion:*' completer _complete
	zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
}

# less colors
() {
	export LESS_TERMCAP_mb=$'\E[01;31m'
	export LESS_TERMCAP_md=$'\E[01;31m'
	export LESS_TERMCAP_me=$'\E[0m'
	export LESS_TERMCAP_se=$'\E[0m'
	export LESS_TERMCAP_so=$'\E[01;44;33m'
	export LESS_TERMCAP_ue=$'\E[0m'
	export LESS_TERMCAP_us=$'\E[01;32m'
}

zstyle :compinstall filename '/home/shadowkyogre/.zshrc'

fpath=(~/.config/zsh/functions ~/.config/zsh/prompts $fpath)

# history opts
() {
	setopt HIST_IGNORE_DUPS
	setopt APPEND_HISTORY
	HISTSIZE=1000
	SAVEHIST=1000
	HISTFILE=~/.config/zsh/history
}

autoload -Uz compinit promptinit
compinit
promptinit

# aesthetics
() {
	ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=4"
	prompt sk 8bit magenta red red white yellow
}

# actually set up help
() {
	autoload -Uz run-help
	autoload -Uz run-help-git
	autoload -Uz run-help-svn
	autoload -Uz run-help-svk
	unalias run-help
	alias help=run-help
}

# terminal title setting
() {
	typeset -A terms_no_titles
	terms_no_titles[fbpad-256]=y
	terms_no_titles[linux]=y

	precmd() {
		if [ -z "${terms_no_titles[$TERM]}"  ];then
			print -Pn "\e]0;zsh %~\a"
		fi
	}

	preexec() {
		if [ -z "${terms_no_titles[$TERM]}" ];then
			printf "\033]0;%s\a" "$1"
		fi
	}
}

autoload -Uz ~/.config/zsh/functions/*(:t)

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-directory-history/zsh-directory-history.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

source /home/shadowkyogre/.config/zsh/aliases.zsh
source /home/shadowkyogre/.config/zsh/completions.zsh
source /home/shadowkyogre/.config/zsh/keybindings.zsh

eval "$(direnv hook zsh)"
