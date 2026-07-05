# neofetch
# ---------- EXPORT ---------- #
export PATH=$HOME/bin:/usr/local/bin:$PATH

export PATH=$HOME/.cargo.bin:$HOME/.local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

. /opt/asdf-vm/asdf.sh

eval "$(starship init zsh)"

# ---------- PLUGINS ---------- #
plugins=(git)

source $ZSH/oh-my-zsh.sh

# ---------- ALIAS ---------- #
alias sudo="sudo"

alias ls="exa --icons"
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
alias status="git status"

bindkey "^H" backward-kill-word
bindkey "5~" kill-word

# ---------- ZINIT ---------- #
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
    print -P "%F{33} %F{34}Installation successful.%f%b" || \
    print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions