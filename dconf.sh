#!/bin/sh
dconf load / < ~/.config/gnome-settings.conf
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
rm -f ~/.config/gnome-settings.conf ~/.config/autostart-scripts/dconf.sh &
