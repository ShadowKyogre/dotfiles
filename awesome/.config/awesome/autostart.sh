devmon &
compton -b &
setxkbmap -layout us           -model microsoftprousb \
          -variant olpc        -option caps:none \
          -option compose:menu -option keyboard:pointerkeys &
xmodmap ~/.Xmodmap &
copyq &
volumeicon &
kupfer --no-splash &
xscreensaver -no-splash &
syncthing-gtk &
