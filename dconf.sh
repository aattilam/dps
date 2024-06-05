#!/bin/sh
dconf load / < ~/.config/gnome-settings.conf
rm -f ~/.config/gnome-settings.conf ~/.config/autostart-scripts/dconf.sh &
