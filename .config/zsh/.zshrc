setopt appendhistory autocd extendedglob
setopt no_complete_aliases

# completion opts
() {
	zstyle ':completion:*' list-colors ''
	zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
	zstyle ':completion:*' menu select=1
	zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
}

# man page completions
() {
	zstyle ':completion:*:man:*' menu yes select
	zstyle ':completion:*:manuals' separate-sections true
	zstyle ':completion:*:manuals.*' insert-sections true
}

# file completion in middle
() {
	zstyle ':completion:*' completer _complete
	zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
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
