#!/bin/bash

(
echo 0
sleep 1

# Function to install GNOME extension
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

# Extensions list
extensions=(
  "appindicatorsupport@rgcjonas.gmail.com"
  "tiling-assistant@leleat-on-github"
  "arcmenu@arcmenu.com"
  "dash-to-panel@jderose9.github.com"
  "ding@rastersoft.com"
)

total_steps=$(( ${#extensions[@]} + 3 ))  # Number of extensions + dconf load + gsettings + cleanup
current_step=0

for uuid in "${extensions[@]}"; do
  install_gnome_extension "$uuid" "$shell_version"
  current_step=$((current_step + 1))
  progress=$((current_step * 100 / total_steps))
  echo $progress
done

# Load GNOME settings
dconf load / < ~/.config/gnome-settings.conf
current_step=$((current_step + 1))
progress=$((current_step * 100 / total_steps))
echo $progress

# Set GTK theme
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
current_step=$((current_step + 1))
progress=$((current_step * 100 / total_steps))
echo $progress

# Clean up
rm -f ~/.config/gnome-settings.conf ~/.config/dconf.sh
current_step=$((current_step + 1))
progress=$((current_step * 100 / total_steps))
echo $progress

echo 100
sleep 1

# Logout the session
reboot now

) | zenity --progress \
            --title="System Update" \
            --text="The system will update. Please wait a moment." \
            --percentage=0 \
            --no-cancel \
            --width=300 \
            --height=100
