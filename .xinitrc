#!/bin/sh

#somehow, dbus fails when the login manager is killed
#also, it hangs until the child session is killed?, seems to only happen with KDE
#somehow cannot log into GUI again after first login?

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f" &
    done
    unset f
fi
#export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
exec ${1}

#exec dbus-launch ck-launch-session pekwm
#exec dbus-launch ck-launch-session compiz-alone-session --sm-disable
#exec dbus-launch ck-launch-session compiz --sm-disable ccp
#exec ck-launch-session fvwm-crystal

#ob-autostart -d &
#exec ck-launch-session fluxbox

#ck-launch-session compiz --indirect-rendering --sm-disable ccp &
#ob-autostart -d &
#exec emerald --replace

#ob-autostart -d &
#exec ck-launch-session dbus-launch compiz-git --sm-disable ccp
#exec ck-launch-session compiz-git --indirect-rendering --sm-disable ccp

#exec compiz-alone-session --sm-disable
#exec ck-launch-session dbus-launch compiz-alone-session

#exec dbus-launch ck-launch-session roxterm
