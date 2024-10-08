#!/bin/bash

if [[ "$EUID" -ne 0 ]]; then
  echo "Please run this script with sudo."
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

echo "Setting up repositories"

rm /etc/apt/sources.list
touch /etc/apt/sources.list

cat <<EOT >> /etc/apt/sources.list

deb http://deb.debian.org/debian testing main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian testing main contrib non-free non-free-firmware

deb http://deb.debian.org/debian-security/ testing-security main contrib non-free
deb-src http://deb.debian.org/debian-security/ testing-security main contrib non-free

deb http://deb.debian.org/debian sid main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian sid main contrib non-free non-free-firmware
EOT

dpkg --add-architecture i386
apt-get update && apt-get upgrade -y && apt-get autoremove -y

echo "Installing base packages"
apt-get install -y gnome-core zenity gir1.2-gnomedesktop-3.0 libreoffice libreoffice-gnome sudo gnome-tweaks gnome-initial-setup curl git htop gnome-boxes software-properties-gtk laptop-detect flatpak network-manager gnome-software-plugin-flatpak chrome-gnome-shell adwaita-qt adwaita-qt6 firmware-linux-nonfree firmware-misc-nonfree rar unrar libavcodec-extra gstreamer1.0-libav gstreamer1.0-plugins-ugly gstreamer1.0-vaapi ffmpeg lm-sensors isenkram network-manager-gnome wget
apt-get purge -y firefox-esr
apt-get install -y firefox

echo "Setting up flathub"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Installing kernel headers"
apt-get install -y linux-headers-amd64

echo "Installing drivers"

graphics=$(lspci -nn | egrep -i "3d|display|vga")

# Check if the output contains NVIDIA
if echo "$graphics" | grep -qi "NVIDIA"; then
  apt-get install -y nvidia-detect nvidia-driver nvidia-smi mesa-vulkan-drivers libglx-mesa0:i386 mesa-vulkan-drivers:i386 libgl1-mesa-dri:i386
# Check if the output contains AMD
elif echo "$graphics" | grep -qi "AMD"; then
  apt-get install -y firmware-amd-graphics libgl1-mesa-dri libvulkan1 vulkan-tools vulkan-validationlayers libdrm-amdgpu1 libglx-mesa0 mesa-vulkan-drivers libglx-mesa0:i386 mesa-vulkan-drivers:i386 libgl1-mesa-dri:i386 radeontop fancontrol
fi

isenkram-autoinstall-firmware

if laptop-detect >/dev/null 2>&1; then
    echo "Laptop detected. Installing task-laptop package..."
    apt-get install -y task-laptop
else
    echo "No laptop detected installing lqx kernel."
    curl 'https://liquorix.net/install-liquorix.sh' -o liquorix.sh; chmod +x liquorix.sh; ./liquorix.sh; rm liquorix.sh;
fi

echo "Fixing NetworkManager https://wiki.debian.org/NetworkManager#Wired_Networks_are_Unmanaged"

nmandefault="# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback
"

cp /etc/network/interfaces /etc/network/interfaces.bak
echo "$nmandefault" > /etc/network/interfaces

if grep -q "^\[ifupdown\]" /etc/NetworkManager/NetworkManager.conf; then
    if grep -q "^\[ifupdown\]" /etc/NetworkManager/NetworkManager.conf && grep -q "^managed=" /etc/NetworkManager/NetworkManager.conf; then
        sed -i '/^\[ifupdown\]/,/^$/ {s/^managed=.*/managed=true/;}' /etc/NetworkManager/NetworkManager.conf
    else
        sed -i '/^\[ifupdown\]/ a managed=true' /etc/NetworkManager/NetworkManager.conf
    fi
else
    echo -e "\n[ifupdown]\nmanaged=true" >> /etc/NetworkManager/NetworkManager.conf
fi

echo "Interface management enabled in /etc/NetworkManager/NetworkManager.conf"

echo "Installing wine"
apt-get install -y wine wine32 wine64 libwine libwine:i386 fonts-wine

echo "Setting up gtk themes"
mkdir -p /etc/skel
mkdir -p /etc/skel/.themes

wget https://github.com/lassekongo83/adw-gtk3/releases/download/v5.3/adw-gtk3v5.3.tar.xz
tar -xf adw-gtk3v5.3.tar.xz -C /usr/share/themes
tar -xf adw-gtk3v5.3.tar.xz -C /etc/skel/.themes
flatpak install -y org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark
rm adw-gtk3v5.3.tar.xz

git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes
./install.sh -t tela -s 1080p
cd ..
rm -r grub2-themes

apt-get autoremove -y
echo "The installation is complete, please reboot"
passwd -d root
