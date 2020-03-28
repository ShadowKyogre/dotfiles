###Check for an interactive session###
[ -z "$PS1" ] && return
#for pkg in *; do ( cd "$pkg"; makepkg -i ); done
stty stop ''
[ -f "${HOME}/.bash_private" ] && source "${HOME}/.bash_private"

###One-Time Greetings###
#img2txt $HOME/.face.icon -H 20 -W 40 -f utf8 > .avatar.txt;cat .avatar.txt

###Options###
shopt -s cdspell          # autocorrects cd misspellings
shopt -s cmdhist          # save multi-line commands in history as single line
shopt -s dotglob          # include dotfiles in pathname expansion
shopt -s extglob
shopt -s autocd
shopt -s checkwinsize #checks after each command to see how large window is
stty -ctlecho

###VARS###
# migrated to ~/.bash_vars

###Less colors###
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
###Aliases###
alias tree="tree -C"
alias nhalt="sudo ninit-shutdown -o"
alias nreboot="sudo ninit-shutdown -r"
alias ytmp4="youtube-dl -f mp4 -a"
alias ytmp3="youtube-dl -x --audio-format mp3 -a"
alias pyserve="python -m http.server"
alias reload='source ~/.bashrc'
alias ls='ls --color=auto -X --human-readable -s -p'
alias udb='aurman -Sy'
alias pkgin='aurman -S'
#alias abbin='sudo bauerbill -S --aur --abs --editor $EDITOR'
alias pkgq='aurman -Si'
alias pkgs='aurman -Ss'
alias pkgis='aurman -Qs'
alias pkgi='aurman -Q'
alias pkgiq='aurman -Qi'
alias lspkg='aurman -Ql'
alias rmpkg='aurman -R'
alias rmpkgr='aurman -Rsnc'
alias pkgu='aurman -Syu'
#alias lsaur='bauerbill -Ss --aur $(aurman -Qm) | grep 'AUR/' | grep installed'
alias lsorphs='aurman -Qdt'
alias rmorphs='aurman -Qdtq | sudo aurman -Rs -'
alias whichpkg='aurman -Qo'
alias getpkg='aurman -d'
alias lpkgin='sudo aurman -U'
alias nicc='sudo aurman -Sc'
alias allcc='sudo aurman -Scc'
alias ftype='file -b --mime-type'
alias ftail='tail -n+1'
alias xml2xsd='java -jar /usr/share/java/trang.jar'
alias vim='vim -p'
alias less='less -r'

# alias urepo='spaceman --update-repos'
# alias pkgin='sudo spaceman -i'
# alias udb='sudo spaceman -y'
# alias pkgu='sudo spaceman -u'
# alias pkgq='spaceman -S'
# alias apkgq='spaceman --repos aur-* -S'
# alias pkgiq='spaceman -IS'
# alias showpkgs='cat /var/db/pkg/installed|awk -F : '\''{print $1}'\'''
# alias lspkg='spaceman -l'
# alias rmpkg='sudo spaceman -R'
# alias bbu='sudo spaceman -u'
# alias lsaur='bauerbill -Ss --aur $(aurman -Qm) | grep '\''AUR/'\'' | grep installed'
# #alias lsorphs='aurman -Qdt'
# alias whichpkg='spaceman -o'
# alias getpkg='spaceman --get-pkgbuild'
# alias dbgpkg='spaceman -b --keep'
# alias bldpkg='spaceman -b'
# #alias nicc='sudo aurman -Sc'
# alias allcc='sudo rm -rfv /var/cache/spaceman/pkg/*'

alias saneperms='find . -type f -exec chmod a-x -v {} \;'
alias history='history|cut -c 8-|zenity --list --column History'
alias grep='grep --color=auto'
alias myip='curl www.whatismyip.org'
alias ebrc='nano $HOME/.bashrc'
alias rm='rm -iv'
alias cp='cp -iv'
alias mv='mv -iv'
alias idof='ps aux|grep --color=auto'
alias conkyreset='killall -SIGUSR1 conky'
alias ps='ps aux'
alias pacgraph='pacgraph -b "#000000" -l "#8800FF" -t "#0000FF" -d "#FF0000"'
alias open='exo-open'

###Functions###

clean_dropbox()
{
	IFS="
"
	#files=$(find  ~/Dropbox -name "*'s conflicted copy*")
	files=$(find ~/Dropbox -regextype posix-extended -regex '.*\([0-9]+\).*')
	if ! test -z "${files}";then
		rm -vi $files
	else
		echo "No conflicted copies found"
	fi
}

xgo()
{
	vt=$(fgconsole 2>/dev/null)
	if [[ ! -z $vt ]];then
		exec startx ~/.xinitrc $1 -- vt$vt &> /dev/null
	fi
}

helloworld()
{
	echo 'This is to show you that this is sets custom functions that need more than 1 line.'
}

## remind me, its important! usage: remind <time> <text> e.g.: remind 10m "omg, the pizza"
remind()
{
    sleep $1 && zenity --warning --text "$2" &
}

##Generates an ASCII avatar from your .face.icon file##
txtavatar()
{
        img2txt $HOME/.face.icon -H 20 -W 40 -f utf8 > .avatar.txt
        cat .avatar.txt
}

m4a2mp3()
{
	for i in *.m4a
	do
	ffmpeg -i $i -sameq ${i%m4a}mp3
	done
}

flv2mp3()
{
	for i in *.flv
	do
	ffmpeg -i $i -ar 44100 -ab 160k -ac 2 ${i%flv}mp3
	done
}

pgwall()
{
	pacgraph -b "#000000" -l "#8800FF" -t "#0000FF" -d "#FF0000" --svg
	convert pacgraph.svg -resize 1680x1050\^ -gravity center -extent 1680x1050 $HOME/Pictures/WallPaper/pacgraph.png
	rm -f $HOME/pacgraph.svg
}

fswidget()
{
	 gdmap -f $HOME & disown -a
	sleep 10
	import -window "Graphical Disk Map 0.8.1" test.jpg
	killall gdmap
	convert test.jpg -crop 700x336+0+84 test.jpg
}

##Usage: msg (source) (end), leave blank for autotranslation to English
qtran(){
	wget -qO- "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=$1&langpair=$2|${3:-en}" | sed 's/.*"translatedText":"\([^"]*\)".*}/\1\n/';
}

define(){
	dict $1 > /tmp/lookup.txt
	zenity --text-info --filename=/tmp/lookup.txt --window-icon="$HOME/.icons/Breathless/48x48/apps/kdict.png" --title="Definition of $1"
}

infodev(){
	udevadm info -a -p $(udevadm info -q path -n $1)
}

guiquit(){
	quitconfirm="$(zenity --question --text="Do you want to log out?";echo $?)"
	if [[ "$quitconfirm" == "0"  ]];then
		skill -TERM -u $(whoami) & sleep 5 && skill -KILL -u $(whoami) && sync
	fi
}

massbuild()
{
	wow=`pwd`
	for i in $(ls);do
	cd ${wow}/${i}
	bldpkg
	done
}

countdown()
(
  IFS=:
  set -- $*
  secs=$(( ${1#0} * 3600 + ${2#0} * 60 + ${3#0} ))
  while [ $secs -gt 0 ]
  do
    sleep 1 &
    printf "\r%02d:%02d:%02d" $((secs/3600)) $(( (secs/60)%60)) $((secs%60))
    secs=$(( $secs - 1 ))
    wait
  done
  echo
  ffplay -autoexit /usr/share/sounds/KDE-Sys-App-Error-Critical.ogg
)

function bashtips {
cat <<EOF
DIRECTORIES
-----------
~-      Previous working directory
pushd tmp   Push tmp && cd tmp
popd            Pop && cd

GLOBBING AND OUTPUT SUBSTITUTION
--------------------------------
ls a[b-dx]e Globs abe, ace, ade, axe
ls a{c,bl}e Globs ace, able
\$(ls)          \`ls\` (but nestable!)

HISTORY MANIPULATION
--------------------
!!      Last command
!?foo           Last command containing \`foo'
^foo^bar^   Last command containing \`foo', but substitute \`bar'
!!:0            Last command word
!!:^            Last command's first argument
!\$     Last command's last argument
!!:*            Last command's arguments
!!:x-y          Arguments x to y of last command
C-s     search forwards in history
C-r     search backwards in history

LINE EDITING
------------
M-d     kill to end of word
C-w     kill to beginning of word
C-k     kill to end of line
C-u     kill to beginning of line
M-r     revert all modifications to current line
C-]     search forwards in line
M-C-]           search backwards in line
C-t     transpose characters
M-t     transpose words
M-u     uppercase word
M-l     lowercase word
M-c     capitalize word

COMPLETION
----------
M-/     complete filename
M-~     complete user name
M-@     complete host name
M-\$            complete variable name
M-!     complete command name
M-^     complete history
EOF
}

pkgs_using_dir()
{
ROOT=${2:-/}
grep "^${1}/" -l ${ROOT}/var/lib/pacman/local/*/files
}

#pkgs_w_missing_files()
#{
#need_to_reinstall=""
#pacman -Qq|while read package
#do
#	pacman -Ql ${package}|while read f
#	do
#		if [[ ! -e "/${f}"]];then
#			need_to_reinstall="${package} ${need_to_reinstall}"
#			break;
#		fi
#	done
#done
#echo ${need_to_reinstall}
#}

edit_other_arch() {
new_arch=$1
sudo mount -v UUID=1be61605-fb6a-40ae-8cf3-bc25b796177c ${new_arch}
sudo mount -v UUID=6bba4306-5bc3-4b95-971d-a6c6817ad560 ${new_arch}/boot 
sudo mount -v -t proc proc ${new_arch}/proc
sudo mount -v -t sysfs sys ${new_arch}/sys
sudo mount -v -o bind /dev ${new_arch}/dev
sudo chroot ${new_arch} /bin/bash
}

remove_other_arch()
{
new_arch=$1
sudo umount -v ${new_arch}/{boot,proc,sys,dev}
sudo umount -v ${new_arch}
}

wgit()
{
	if (( $# == 2 ));then
		git clone "git@github.com:${1}/${2}.git"
	elif (( $# == 1 ));then
		git clone "git@github.com:ShadowKyogre/${1}.git"
	else
		git clone "git@github.com:${1}/${2}.git" -b "${3}"
	fi
}

grepplog()
{
cd ~/.purple/logs"/${2,,}"
if [ $# -gt 4 ];then
	tar -jcvf "${5}" $(grep -lr "${1}" "${3,,}/${4,,}")
elif [ $# -eq 4 ];then
	grep -lr "${1}" "${3,,}/${4,,}"
else
	echo "Not enough arguments!"
fi
cd -
}

list_exe_icons() {
    wrestool -l "$1" | grep group_icon | awk '{ print $2}' | cut -f2 -d=
}

psd2tiff()
{
    convert "${1}"  -channel RGBA -alpha Set -colorspace rgb "${2}"
}

newwineprefix()
{
    if [[ -z "${1}" ]];then
        echo "Sorry, can't make another wine prefix without a parameter"
        return 1
    fi
    WINEPREFIX="${HOME}/.local/share/wineprefixes/${1}" WINEARCH="${2:-win32}" wine wineboot
}

if [ "$TERM" == "linux" ];then
	setcolors ~/.setcolorsrc
	clear
fi

###Colors for reference###
black='\[\e[0;30m\]'
blue='\[\e[0;34m\]'
green='\[\e[0;32m\]'
cyan='\[\e[0;36m\]'
red='\[\e[0;31m\]'
magenta='\[\e[0;35m\]'
brown='\[\e[0;33m\]'
lightgray='\[\e[0;37m\]'
darkgray='\[\e[1;30m\]'
lightblue='\[\e[1;34m\]'
lightgreen='\[\e[1;32m\]'
lightcyan='\[\e[1;36m\]'
lightred='\[\e[1;31m\]'
lightmagenta='\[\e[1;35m\]'
yellow='\[\e[1;33m\]'
white='\[\e[1;37m\]'
nc='\[\e[0m\]'
violet="\[\033[0;38;5;55m\]"

###PROMPTS###
##Avatar Prompt
#PROMPT_COMMAND=txtavatar
#PS1="$violet[$red\t$violet]─[$red$(date '+%a %b %d %Y')$violet]─[$red\W$violet|$green\$$violet]──>$nc"

##SA Short prompt
#PS1="$violet[$red\u@\h$violet]─[$red\t$violet]─[$red$(date '+%a %b %d %Y')$violet]─[$red\W$violet|$green\$$violet]──>$nc"

##ASCII SNAKE
PS1="$violet _____/[$lightred\u@\h$violet|$lightred\t$violet|$lightred$(date '+%a %b %d %Y')$violet]\______________)\n$violet(_/[$lightred\W$violet]\_____________/($lightred($yellow\$$lightred)$violet>$lightred--< $nc"
PS2="-> "
