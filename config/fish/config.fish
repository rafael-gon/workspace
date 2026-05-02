# ---------- FASTFETCH ----------
fastfetch
# ---------- EXPORT ----------
set -g PATH $HOME/bin /usr/local/bin $PATH
set -g PATH $HOME/.cargo.bin $HOME/.local/bin $PATH

# ---------- Starship ----------
starship init fish | source

# ---------- INTERACTIVE SESSION ----------
if status is-interactive
    # Commands to run in interactive sessions can go here
end

# ---------- ALIAS ----------
alias sudo="sudo"
alias nvim="nvim"
alias vim="nvim"
alias vi="nvim"
alias ls="eza --icons"
alias cat="bat --style=auto"
alias ips="ip -c a"
alias ipup="ip -c -br a"
alias size="du -sh * | sort -hr"
alias mkdir="mkdir -pv"
alias rm="rm -rf"
alias off="shutdown now"
alias update="flatpak update -y && yay -Syyuu --noconfirm"
alias install="yay -S"
alias remove="yay -R"
alias purge="yay -Rns"
alias clone="git clone"

# ---------- ASDF ----------
if test -f /opt/asdf-vm/asdf.sh
    source /opt/asdf-vm/asdf.sh
end
