#!/bin/bash
install_gnome_extension() {
  uuid=$1
  shell_version=$2
  
  info_json=$(curl -sS "https://extensions.gnome.org/extension-info/?uuid=$uuid&shell_version=$shell_version")
  download_url=$(echo $info_json | jq ".download_url" --raw-output)
  
  if [ "$download_url" != "null" ]; then
    gnome-extensions install "https://extensions.gnome.org$download_url"
    echo "Installed extension: $uuid"
  else
    echo "Failed to find download URL for extension: $uuid"
  fi
}
shell_version=$(gnome-shell --version | grep -oP '\d+\.\d+')
extensions=(
  "appindicatorsupport@rgcjonas.gmail.com"
  "tiling-assistant@leleat-on-github"
  "arcmenu@arcmenu.com"
  "dash-to-panel@jderose9.github.com"
  "ding@rastersoft.com"
)
for uuid in "${extensions[@]}"; do
  install_gnome_extension "$uuid" "$shell_version"
done

dconf load / < ~/.config/gnome-settings.conf
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
rm -f ~/.config/gnome-settings.conf ~/.config/autostart-scripts/dconf.sh &
