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

yay -Syyuu base-devel unzip unrar exa bat wget curl docker alacritty noto-fonts \
       noto-fonts-cjk noto-fonts-emoji noto-fonts-extra inter-font ttf-roboto \
       ttf-ubuntu-font-family ttf-material-icons-git bluez bluez-libs \
       bluez-plugins bluez-utils flatpak asdf-vm nerd-fonts qbittorrent \
       discord dropbox vlc visual-studio-code-bin fastfetch zsh starship \
       google-chrome gnome-keyring wayland xorg-xwayland spotify lazygit ffmpeg github-desktop-bin --noconfirm

asdf plugin add python https://github.com/asdf-community/asdf-python.git
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin add java https://github.com/halcyon/asdf-java.git
asdf plugin add rust https://github.com/code-lever/asdf-rust.git

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
                flathub org.telegram.desktop \
                flathub io.beekeeperstudio.Studio \
                flathub me.timschneeberger.GalaxyBudsClient -y

xdg-mime default org.qbittorrent.qBittorrent.desktop application/x-bittorrent
xdg-mime default org.qbittorrent.qBittorrent.desktop application/x-torrent
xdg-mime default org.qbittorrent.qBittorrent.desktop x-scheme-handler/magnet

# Gnome specific setup
yay -S plasma-desktop bluedevil discover dolphin latte-dock sddm okular ark spectacle \
           gwenview kdeconnect flatpak-kcm kde-gtk-config  kdeplasma-addons kinfocenter \
           kpipewire kscreen kscreenlocker ksystemstats kwin plasma-nm plasma-pa plasma-sdk \
           plasma-systemmonitor plasma-workspace sddm-kcm systemsettings xdg-desktop-portal-kde \
           libdbusmenu-glib packagekit-qt5 --noconfirm

sudo -n systemctl enable sddm

kill "$!" 2>/dev/null
