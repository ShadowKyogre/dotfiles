# File management
() {
	alias rm='rm -vi'
	alias rmdir='rmdir -v'
	alias mkdir='mkdir -v'
	alias cp='cp -uvi'
	alias mv='mv -uvi'
	alias chmod='chmod -v'
	alias ftype='file -b --mime-type'
	alias ftail='tail -n+1'
	alias grep='grep --color=auto'
	alias less='less -r'
	alias - -='cd -'

	alias coms_collabs="START_HERE=~/art/stories/coms_collabs storytime"
	alias rps="START_HERE=~/art/stories/rp storytime"
	alias xournalpp='GTK_THEME=Blue-Submarine:dark xournalpp'
}

# Development
() {
	alias git-status-rec='find . -maxdepth 2 -name .git -execdir git rev-parse --show-toplevel \; -execdir git status -s \;'
}

# Package Administration
() {
	alias udb='yay -Sy'
	alias ufdb='yay -Fy'
	alias pkgin='yay -S'
	alias pkgq='yay -Si'
	alias pkgs='yay -Ss'
	alias pkgis='yay -Qs'
	alias pkgi='yay -Q'
	alias pkgiq='yay -Qi'
	alias lspkg='yay -Ql'
	alias rmpkg='yay -R'
	alias rmpkgr='yay -Rsnc'
	alias pkgu='yay -Syu'
	alias lsorphs='yay -Qdt'
	alias rmorphs='yay -Qdtq | yay -Rs -'
	alias whichpkg='yay -Qo'
	alias getpkg='yay -d'
	alias lpkgin='yay -U'
	alias nicc='yay -Sc'
	alias allcc='yay -Scc'
	alias testmkpkg='makepkg -C --noarchive'
	alias aurcheck='yay -k'
	alias bigpkgs="expac -Q -H M '%m\t%n'|sort  -n -r|less"
	alias mksrcinfo="makepkg --printsrcinfo"
}

# Sys admin
() {
	alias lsufw='sudo ufw status numbered'
}

# misc
() {
	alias ezrc="${EDITOR:-vim} ~/.config/zsh/.zshrc"
	alias reload="source ~/.config/zsh/.zshrc"
	alias ptpython="ptpython --config-dir=${HOME}/.config/ptpython"
}

# network
() {
	alias mypubip="dig +short myip.opendns.com @resolver1.opendns.com"
	alias mylanip="ip addr show enp5s0|grep 'inet '"
}
