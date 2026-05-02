#!/bin/bash
set -euo pipefail

# =============================================================================
# Script de instalação e configuração do ambiente SwayFX no Arch Linux
# =============================================================================

# Detectar o usuário real (quem chamou o sudo)
REAL_USER=${SUDO_USER:-$USER}
USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

# Verificar se está sendo executado como root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script precisa ser executado com sudo."
    echo "Uso: sudo bash setup-swayfx.sh"
    exit 1
fi

# Garantir que REAL_USER não seja root
if [ "$REAL_USER" = "root" ]; then
    echo "Erro: execute o script com sudo a partir de um usuário comum, não como root diretamente."
    exit 1
fi

echo ">> Configurando ambiente para o usuário: $REAL_USER ($USER_HOME)"

# =============================================================================
# Atualização do sistema
# =============================================================================
echo ">> Atualizando o sistema..."
pacman -Syyuu --noconfirm

# =============================================================================
# Instalação do yay (AUR helper)
# =============================================================================
if ! command -v yay &> /dev/null; then
    echo ">> yay não encontrado, instalando..."
    pacman -S --noconfirm git base-devel

    YAY_DIR="/tmp/yay-install"
    rm -rf "$YAY_DIR"
    sudo -u "$REAL_USER" git clone https://aur.archlinux.org/yay.git "$YAY_DIR"

    cd "$YAY_DIR"
    sudo -u "$REAL_USER" makepkg -si --noconfirm
    cd /
    rm -rf "$YAY_DIR"
else
    echo ">> yay já está instalado."
fi

# Helper para rodar yay como usuário real
run_yay() {
    sudo -u "$REAL_USER" yay "$@"
}

# =============================================================================
# Fonts
# =============================================================================
echo ">> Instalando fontes..."
run_yay -S --noconfirm \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    noto-fonts-extra \
    inter-font \
    ttf-roboto \
    ttf-ubuntu-font-family \
    ttf-material-icons-git \
    ttf-jetbrains-mono-nerd

# =============================================================================
# Sistema
# =============================================================================
echo ">> Instalando pacotes de sistema..."
run_yay -S --noconfirm \
    bluez \
    bluez-libs \
    bluez-plugins \
    bluez-utils \
    flatpak \
    networkmanager \
    asdf-vm \
    fish \
    starship \
    gnome-keyring \
    wayland \
    xorg-xwayland

# =============================================================================
# CLI
# =============================================================================
echo ">> Instalando ferramentas de linha de comando..."
run_yay -S --noconfirm \
    unzip \
    unrar \
    eza \
    bat \
    wget \
    curl \
    docker \
    fastfetch \
    lazygit \
    ffmpeg

# =============================================================================
# LazyVim (Neovim)
# =============================================================================
echo ">> Instalando LazyVim..."
if [ ! -d "$USER_HOME/.config/nvim" ]; then
    sudo -u "$REAL_USER" git clone https://github.com/LazyVim/starter "$USER_HOME/.config/nvim"
else
    echo ">> ~/.config/nvim já existe, pulando clone do LazyVim."
fi

# =============================================================================
# GUI
# =============================================================================
echo ">> Instalando aplicações GUI..."
run_yay -S --noconfirm \
    kitty \
    qbittorrent \
    discord \
    dropbox \
    vlc \
    visual-studio-code-bin \
    zen-browser-bin \
    spotify \
    github-desktop-bin \
    mpv

# =============================================================================
# SwayFX e ambiente Wayland
# =============================================================================
echo ">> Instalando SwayFX e componentes do ambiente..."
run_yay -S --noconfirm \
    swayfx-git \
    swaylock-effects \
    gvfs \
    thunar \
    thunar-archive-plugin \
    thunar-media-tags-plugin \
    thunar-shares-plugin \
    thunar-volman \
    tumbler \
    libgsf \
    raw-thumbnailer \
    tumbler-folder-thumbnailer \
    tumbler-stl-thumbnailer \
    webp-pixbuf-loader \
    swaybg \
    swaync-git \
    pipewire \
    pipewire-pulse \
    wireplumber \
    viewnior \
    grim \
    slurp \
    xarchiver \
    xclip \
    wl-clipboard \
    light \
    brightnessctl \
    pamixer \
    avizo \
    wofi \
    waybar \
    ly \
    lxappearance \
    kvantum \
    pavucontrol \
    nwg-bar \
    nwg-drawer

# =============================================================================
# Flatpak
# =============================================================================
echo ">> Instalando aplicações via Flatpak..."
sudo -u "$REAL_USER" flatpak install -y flathub \
    com.stremio.Stremio \
    com.calibre_ebook.calibre \
    org.inkscape.Inkscape \
    org.ppsspp.PPSSPP \
    org.duckstation.DuckStation \
    com.heroicgameslauncher.hgl \
    net.pcsx2.PCSX2 \
    org.prismlauncher.PrismLauncher \
    com.snes9x.Snes9x \
    org.telegram.desktop \
    io.beekeeperstudio.Studio

# =============================================================================
# Aplicações padrão (xdg-mime)
# =============================================================================
echo ">> Configurando aplicações padrão..."
sudo -u "$REAL_USER" xdg-mime default org.qbittorrent.qBittorrent.desktop application/x-bittorrent
sudo -u "$REAL_USER" xdg-mime default org.qbittorrent.qBittorrent.desktop application/x-torrent
sudo -u "$REAL_USER" xdg-mime default org.qbittorrent.qBittorrent.desktop x-scheme-handler/magnet
sudo -u "$REAL_USER" xdg-mime default thunar.desktop inode/directory
sudo -u "$REAL_USER" xdg-mime default thunar.desktop application/x-gnome-saved-search

# =============================================================================
# Serviços systemctl
# =============================================================================
echo ">> Habilitando serviços do sistema..."
systemctl enable bluetooth
systemctl enable NetworkManager
systemctl enable docker
systemctl enable ly@tty2.service

echo ">> Habilitando serviços do usuário (pipewire)..."
sudo -u "$REAL_USER" systemctl --user enable pipewire pipewire-pulse wireplumber

# =============================================================================
# NTP (sincronização de tempo)
# =============================================================================
echo ">> Ativando sincronização de tempo (NTP)..."
timedatectl set-ntp true

# =============================================================================
# Copiar arquivos de configuração
# =============================================================================
echo ">> Copiando arquivos de configuração..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -d "$SCRIPT_DIR/config" ]; then
    mkdir -p "$USER_HOME/.config"
    cp -r "$SCRIPT_DIR/config/"* "$USER_HOME/.config/"
    chown -R "$REAL_USER":"$REAL_USER" "$USER_HOME/.config"
    echo ">> Arquivos de config/ copiados para $USER_HOME/.config/"
else
    echo ">> Diretório ./config não encontrado, pulando etapa."
fi

if [ -d "$SCRIPT_DIR/local" ]; then
    mkdir -p "$USER_HOME/.local/share"
    cp -r "$SCRIPT_DIR/local/"* "$USER_HOME/.local/share/"
    chown -R "$REAL_USER":"$REAL_USER" "$USER_HOME/.local/share"
    echo ">> Arquivos de local/ copiados para $USER_HOME/.local/share/"
else
    echo ">> Diretório ./local não encontrado, pulando etapa."
fi

# =============================================================================
# Concluído
# =============================================================================
echo ""
echo "============================================="
echo "  Instalação concluída com sucesso!"
echo "  Usuário configurado: $REAL_USER"
echo "  Reinicie o sistema para aplicar todas as mudanças."
echo "============================================="
