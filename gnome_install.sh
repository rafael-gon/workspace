#!/bin/bash

USER_HOME=$(eval echo $USER_HOME$(whoami))

sudo -v

while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

cd /tmp
sudo -n pacman -S git --noconfirm

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm

cd $USER_HOME

# - - - - - Geral - - - - - #
yay -Syyuu base-devel unzip unrar exa bat wget curl docker kitty noto-fonts \
       noto-fonts-cjk noto-fonts-emoji noto-fonts-extra inter-font ttf-roboto \
       ttf-ubuntu-font-family ttf-material-icons-git bluez bluez-libs \
       bluez-plugins bluez-utils flatpak asdf-vm nerd-fonts  \
       fastfetch fish starship gnome-keyring wayland \
       xorg-xwayland spotify lazygit ffmpeg  --noconfirm

sudo -n systemctl enable bluetooth
sudo -n systemctl --user enable pipewire pipewire-pulse wireplumber

flatpak install flathub com.stremio.Stremio \
                flathub flathub com.calibre_ebook.calibre \
                flathub org.inkscape.Inkscape \
                flathub org.ppsspp.PPSSPP \
                flathub org.duckstation.DuckStation \
                flathub com.heroicgameslauncher.hgl \
                flathub net.pcsx2.PCSX2 \
                flathub org.prismlauncher.PrismLauncher \
                flathub com.snes9x.Snes9x \
                flathub io.dbeaver.DBeaverCommunity \
                flathub org.telegram.desktop \
                flathub org.qbittorrent.qBittorrent \
                flathub com.discordapp.Discord \
                flathub com.dropbox.Client \
                flathub org.videolan.VLC \
                flathub com.visualstudio.code \
                flathub com.google.Chrome \
                flathub com.spotify.Client \
                flathub io.github.shiftey.Desktop \
                flathub com.getpostman.Postman \
                flathub org.mozilla.thunderbird \
                flathub com.heroicgameslauncher.hgl \
                flathub com.valvesoftware.Steam \
                flathub org.kde.krita -y

xdg-mime default org.qbittorrent.qBittorrent.desktop application/x-bittorrent
xdg-mime default org.qbittorrent.qBittorrent.desktop application/x-torrent
xdg-mime default org.qbittorrent.qBittorrent.desktop x-scheme-handler/magnet

# Gnome specific setup
yay -S gnome-shell gnome-shell-extensions gdm gnome-backgrounds gnome-calculator gnome-calendar \
       gnome-characters gnome-color-manager gnome-control-center gnome-font-viewer gnome-menus \
       gnome-session gnome-settings-daemon gnome-software gnome-system-monitor gnome-text-editor \
       loupe nautilus snapshot sushi xdg-desktop-portal-gnome xdg-user-dirs-gtk gnome-tweaks file-roller \
       evince gvfs gvfs-afc gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb  --noconfirm

xdg-mime default nautilus.desktop inode/directory
xdg-mime default nautilus.desktop inode/directory application/x-gnome-saved-search

sudo -n systemctl enable gdm

kill "$!" 2>/dev/null