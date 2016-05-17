# file browsing opts
() {
	setopt autocd
	setopt extendedglob
	setopt globcomplete
	setopt globstarshort
}

# completion opts
() {
	setopt no_complete_aliases
	zstyle ':completion:*' list-prompt "%B%K{blue}%F{yellow}At %p: Hit TAB for more, or the character to insert%k%b%f"
	zstyle ':completion:*' menu yes select
	zstyle ':completion:*' select-prompt "%B%K{blue}%F{yellow}Scrolling active: current selection at %p%k%b%f"
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
	zstyle ':completion:*:(functions|aliases)' list-colors \
		'=(#b)(*)-- (*)=35;1=31;1=33;1'
	zstyle ':completion:*:(options|values)' list-colors \
		'=(#b)(*)-- (*)=35;1=31;1=33;1' '=*=31;1'
	eval "$(dircolors -b)"
	zstyle ':completion:*' list-colors "${LS_COLORS}"
	zstyle ':completion:*:default' list-colors 'ma=44;33;1'
}

# file completion in middle
() {
	zstyle ':completion:*' completer _complete
	zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
}

# vcs info general options
() {
	zstyle ':vcs_info:*' enable git cvs svn hg
}

zstyle :compinstall filename '/home/shadowkyogre/.zshrc'

fpath=(~/.config/zsh/functions ~/.config/zsh/prompts $fpath)
path=(~/bin ~/bin/compiz_utils ~/bin/compiz_pipes $path)

# history opts
() {
	setopt histignorealldups
	setopt incappendhistory
	HISTSIZE=1000
	SAVEHIST=1000
	HISTFILE=~/.config/zsh/history
}

autoload -Uz compinit promptinit
compinit
promptinit

# aesthetics
() {
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
	typeset -gA TERMS_NO_TITLES
	TERMS_NO_TITLES[fbpad-256]=y
	TERMS_NO_TITLES[linux]=y

	precmd() {
		if [[ -z "${TERMS_NO_TITLES[$TERM]}"  ]];then
			print -Pn "\e]0;zsh %~\a"
		fi
	}

	preexec() {
		if [[ -z "${TERMS_NO_TITLES[$TERM]}" ]];then
			printf "\033]0;%s\a" "$1"
		fi
	}
}

percol_select_history()
{
	local OLDBUFFER="${BUFFER}"
	local EXTRANULL="\0"
	local DIRHISTY="$(echo -E "$(dirhist -a -d "${PWD}")${EXTRANULL}"|tr '\0\n' '\n\0'|head -n-1)"
	local SELECTION="$(echo -E "$DIRHISTY"|tac|peco --query="${OLDBUFFER}" --layout=bottom-up)"
	if [ "$?" -ne 0 ];then
		BUFFER="${OLDBUFFER}"
	else
		BUFFER="$(echo -E "$SELECTION"|tr '\0\n' '\n\0'|tr -d '\0'|tail -n+2)"
	fi

	CURSOR="${#BUFFER}"
	zle -R -c
}


autoload -Uz ~/.config/zsh/functions/*(:t)

#source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-directory-history/zsh-directory-history.zsh

source /home/shadowkyogre/.config/zsh/aliases.zsh
source /home/shadowkyogre/.config/zsh/completions.zsh
source /home/shadowkyogre/.config/zsh/keybindings.zsh
source /home/shadowkyogre/.config/zsh/plugin-overrides.zsh

eval "$(direnv hook zsh)"
