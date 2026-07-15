#!/bin/bash
set -e

USER_HOME="$HOME"

sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &
KEEPALIVE_PID=$!

cd /tmp

# - - - - - Base do sistema - - - - - #
# build-essential = equivalente ao base-devel do Arch
sudo apt update
sudo apt install -y \
  build-essential \
  unrar \
  git \
  curl \
  wget \
  gnupg \
  ca-certificates \
  apt-transport-https \
  software-properties-common \
  ffmpeg \
  gnome-tweaks

# - - - - - eza (exa) e bat - - - - - #
# no Ubuntu o pacote se chama 'bat', mas o binário fica como 'batcat'
sudo apt install -y bat
# eza não está nos repositórios padrão até versões mais recentes; instala via repo oficial
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza

# - - - - - Docker - - - - - #
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker "$USER"

# - - - - - Fontes (as que não vêm por padrão) - - - - - #
sudo apt install -y fonts-noto-extra fonts-roboto fonts-inter
# nerd fonts não têm pacote apt padrão; instala manualmente
mkdir -p ~/.local/share/fonts
cd /tmp
wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -O JetBrainsMono.zip
unzip -oq JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
fc-cache -f

# - - - - - Terminal / shell / prompt - - - - - #
sudo apt install -y zsh fastfetch lazygit

# starship não está nos repositórios padrão
curl -sS https://starship.rs/install.sh | sh -s -- -y

# - - - - - Apps que precisam de repositório próprio - - - - - #

# Google Chrome
wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y /tmp/chrome.deb

# Visual Studio Code
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo gpg --dearmor -o /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install -y code

# Spotify
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/spotify.gpg
echo "deb [signed-by=/etc/apt/keyrings/spotify.gpg] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update
sudo apt install -y spotify-client

# - - - - - Via Snap (mais simples para alguns) - - - - - #
sudo apt install -y snapd

# GitHub Desktop não é oficial no Linux; usar o fork da comunidade (shiftkey)
wget -q https://github.com/shiftkey/desktop/releases/latest/download/GitHubDesktop-linux-amd64.deb -O /tmp/github-desktop.deb
sudo apt install -y /tmp/github-desktop.deb

# - - - - - Apps comuns que não vêm por padrão no Ubuntu - - - - - #
sudo apt install -y vlc


# - - - - - Flatpak (não vem instalado por padrão) - - - - - #
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


cd "$USER_HOME"
kill "$KEEPALIVE_PID" 2>/dev/null