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
}

# Package Administration
() {
	alias udb='aurman -Sy'
	alias ufdb='aurman -Fy'
	alias pkgin='aurman -S'
	alias pkgq='aurman -Si'
	alias pkgs='aurman -Ss'
	alias pkgis='aurman -Qs'
	alias pkgi='aurman -Q'
	alias pkgiq='aurman -Qi'
	alias lspkg='aurman -Ql'
	alias rmpkg='aurman -R'
	alias rmpkgr='aurman -Rsnc'
	alias pkgu='aurman -Syu'
	alias lsorphs='aurman -Qdt'
	alias rmorphs='aurman -Qdtq | aurman -Rs -'
	alias whichpkg='aurman -Qo'
	alias getpkg='aurman -d'
	alias lpkgin='aurman -U'
	alias nicc='aurman -Sc'
	alias allcc='aurman -Scc'
	alias testmkpkg='makepkg -C --noarchive'
	alias aurcheck='aurman -k'
	alias bigpkgs="expac -Q -H M '%m\t%n'|sort  -n -r|less"
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
