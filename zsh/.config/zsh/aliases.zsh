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
	alias udb='pacaur -Sy'
	alias ufdb='pacaur -Fy'
	alias pkgin='pacaur -S'
	alias pkgq='pacaur -Si'
	alias pkgs='pacaur -Ss'
	alias pkgis='pacaur -Qs'
	alias pkgi='pacaur -Q'
	alias pkgiq='pacaur -Qi'
	alias lspkg='pacaur -Ql'
	alias rmpkg='pacaur -R'
	alias rmpkgr='pacaur -Rsnc'
	alias pkgu='pacaur -Syu'
	alias lsorphs='pacaur -Qdt'
	alias rmorphs='pacaur -Qdtq | pacaur -Rs -'
	alias whichpkg='pacaur -Qo'
	alias getpkg='pacaur -d'
	alias lpkgin='pacaur -U'
	alias nicc='pacaur -Sc'
	alias allcc='pacaur -Scc'
	alias testmkpkg='makepkg -C --noarchive'
	alias aurcheck='pacaur -k'
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
}
