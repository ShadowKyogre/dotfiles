bindkey -e

# Common key fixes
() {
	# key bindings
	bindkey "\e[1~" beginning-of-line
	bindkey "\e[4~" end-of-line
	bindkey "\e[5~" beginning-of-history
	bindkey "\e[6~" end-of-history
	bindkey "\e[3~" delete-char
	bindkey "\e[2~" quoted-insert
	bindkey "\e[5C" forward-word
	bindkey "\eOc" emacs-forward-word
	bindkey "\e[5D" backward-word
	bindkey "\eOd" emacs-backward-word
	bindkey "\ee[C" forward-word
	bindkey "\ee[D" backward-word
	bindkey "^H" backward-delete-word

	# for rxvt
	bindkey "\e[8~" end-of-line
	bindkey "\e[7~" beginning-of-line

	# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
	bindkey "\eOH" beginning-of-line
	bindkey "\eOF" end-of-line

	# for freebsd console
	bindkey "\e[H" beginning-of-line
	bindkey "\e[F" end-of-line

	# completion in the middle of a line
	bindkey '^i' expand-or-complete-prefix
}

# edit command-line in EDITOR
() {
	autoload -Uz edit-command-line
	zle -N edit-command-line
	bindkey "^X^E" edit-command-line
}

# Fish-like history subsearch
() {
	# Use for prioritized cwd history
	bindkey '\e[A' history-substring-search-up
	bindkey '\e[B' history-substring-search-down

	# Use for restricted cwd history
	bindkey '^j' directory-history-search-backward
	bindkey '^k' directory-history-search-forward
}

# history menu powers go!
() {
	zle -N percol_select_history
	bindkey '^R' percol_select_history

	# redundant with percol menu
	bindkey -r '^S'
}
