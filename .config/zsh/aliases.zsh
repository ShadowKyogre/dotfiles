# File management
() {
	alias rm='rm -vi'
	alias cp='cp -uvi'
	alias mv='mv -uvi'
	alias chmod='chmod -v'
	alias ftype='file -b --mime-type'
	alias ftail='tail -n+1'
	alias ll='ls -l --color=auto -X --indicator-style=classify --human-readable -s --group-directories-first -u'
	alias less='less -r'
}

# Package Administration
() {
	alias udb='pacaur -Sy'
	alias pkgin='pacaur -S'
	alias pkgq='pacaur -Si'
	alias pkgs='pacaur -Ss'
	alias pkgis='pacaur -Qs'
	alias pkgi='pacaur -Q'
	alias pkgiq='pacaur -Qi'
	alias lspkg='pacaur -Ql'
	alias rmpkg='sudo pacaur -R'
	alias rmpkgr='sudo pacaur -Rsnc'
	alias pkgu='pacaur -Syu'
	alias lsorphs='pacaur -Qdt'
	alias rmorphs='pacaur -Qdtq | sudo pacaur -Rs -'
	alias whichpkg='pacaur -Qo'
	alias getpkg='pacaur -d'
	alias lpkgin='sudo pacaur -U'
	alias nicc='sudo pacaur -Sc'
	alias allcc='sudo pacaur -Scc'
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
	alias wgit='noglob wgit'
}
