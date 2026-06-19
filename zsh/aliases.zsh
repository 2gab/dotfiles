# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Git
alias gs="git status"
alias ga="git add"
alias gaa="git add ."
alias gc="git commit"
alias gcm="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gl="git log --oneline --graph --decorate --all"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"

# Arch Linux
alias update="sudo pacman -Syu"
alias install="sudo pacman -S"
alias remove="sudo pacman -Rns"
alias search="pacman -Ss"
alias clean="sudo pacman -Rns \$(pacman -Qtdq)"

# Utilities
alias reload="source ~/.zshrc"
alias c='clear && printf "\033[3J\033[H\033[2J"'
alias open="xdg-open"
alias mkdir="mkdir -pv"

# Docker
alias dps="docker ps"
alias dpa="docker ps -a"
alias di="docker images"
alias dcu="docker compose up"
alias dcud="docker compose up -d"
alias dcd="docker compose down"
alias dcl="docker compose logs -f"

# Replacements
alias ls="eza --icons"
alias ll="eza -la --icons"
alias la="eza -a --icons"
alias tree="eza --tree --icons"
alias cat="bat"

# Quick edit dotfiles
alias zshrc="nvim ~/dotfiles/zsh/.zshrc"
alias aliases="nvim ~/dotfiles/zsh/aliases.zsh"
alias exports="nvim ~/dotfiles/zsh/exports.zsh"

# Troubleshooting
alias code "code --password-store=gnome-libsecret"
