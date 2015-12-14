#!/bin/sh

#somehow, dbus fails when the login manager is killed
#also, it hangs until the child session is killed?
#was able to trigger it again  with not having an & after sourcing file in xinitrc.d
#somehow cannot log into GUI again after first login?

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -r "$f" ] && . "$f"
#        [ -x "$f" ] && . "$f" &
    done
    unset f
fi

#export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
[[ -f ~/.config/xrdb/default.xrdb ]] && xrdb -merge -I$HOME/.config/xrdb ~/.config/xrdb/default.xrdb

if [ -x "$HOME/.config/awesome/autostart.sh" -a "$1" = "awesome" ];then
	sleep 5 && "$HOME/.config/awesome/autostart.sh" &
fi

exec ${1:-compiz-alone-session}

#exec compiz-alone-session
#exec awesome

#exec lilyterm

#exec dbus-launch ck-launch-session pekwm
#exec dbus-launch ck-launch-session compiz-alone-session --sm-disable

#exec ck-launch-session dbus-launch compiz-alone-session

#exec dbus-launch ck-launch-session roxterm
