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
		'=(#b)(*)-- (*)=35;1=31;1=33;1' '=*=31;1'
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
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.config/zsh/history

autoload -Uz compinit promptinit
compinit
promptinit

autoload -Uz ~/.config/zsh/functions/*(:t)

prompt sk 8bit magenta red red

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

source /home/shadowkyogre/.config/zsh/aliases.zsh
source /home/shadowkyogre/.config/zsh/completions.zsh
source /home/shadowkyogre/.config/zsh/keybindings.zsh
