#!/bin/bash

# Delete the .desktop file
desktop_file="$HOME/.config/autostart/postinst.desktop"
if [ -f "$desktop_file" ]; then
    rm "$desktop_file"
fi

dconf load / < dconf-settings.conf

gnome-shell --replace &

# Delete the postinst.sh script
rm /tmp/dconf-settings.conf
rm -- "$0"
