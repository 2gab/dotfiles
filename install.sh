#!/bin/bash

set -euo pipefail

# ─── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
LOG="$DOTFILES/install.log"

log()    { echo -e "${GREEN}✓${RESET} $1" | tee -a "$LOG"; }
warn()   { echo -e "${YELLOW}⚠${RESET} $1" | tee -a "$LOG"; }
info()   { echo -e "${BLUE}→${RESET} $1" | tee -a "$LOG"; }
err()    { echo -e "${RED}✗${RESET} $1" | tee -a "$LOG"; }
section(){ echo -e "\n${BOLD}${CYAN}── $1 ──${RESET}" | tee -a "$LOG"; }

# ─── Init ─────────────────────────────────────────────────────────────────────
echo "Bootstrap started at $(date)" > "$LOG"

echo -e "${BOLD}${CYAN}"
echo "┌────────────────────────────────┐"
echo "│    dotfiles bootstrap v2.0     │"
echo "└────────────────────────────────┘"
echo -e "${RESET}📂 ${BLUE}$DOTFILES${RESET}"
echo ""

# ─── Dependencies ─────────────────────────────────────────────────────────────
section "Dependencies"

for cmd in git stow curl zsh; do
  if command -v "$cmd" >/dev/null 2>&1; then
    log "$cmd"
  else
    err "Missing: $cmd — install it first and re-run"
    exit 1
  fi
done

# ─── Packages ─────────────────────────────────────────────────────────────────
section "System packages"

PACKAGES=(
  # Shell & terminal
  zsh stow kitty
  # Window manager
  i3-wm i3status picom feh
  # Editors
  neovim emacs
  # Fonts
  ttf-jetbrains-mono-nerd
  # Modern CLI replacements
  eza bat ripgrep fd
  # Dev tools
  nvm docker docker-compose
)

if command -v yay >/dev/null 2>&1; then
  info "Using yay"
  yay -S --needed --noconfirm "${PACKAGES[@]}" >> "$LOG" 2>&1 || warn "Some packages may have failed (check $LOG)"
  log "Packages installed"
elif command -v pacman >/dev/null 2>&1; then
  warn "yay not found — using pacman (AUR packages will be skipped)"
  sudo pacman -S --needed --noconfirm "${PACKAGES[@]}" >> "$LOG" 2>&1 || warn "Some packages may have failed (check $LOG)"
  log "Packages installed"
else
  warn "No package manager found — skipping"
fi

# ─── Oh My Zsh ────────────────────────────────────────────────────────────────
section "Oh My Zsh"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    >> "$LOG" 2>&1
  log "Oh My Zsh installed"
else
  log "Oh My Zsh already present"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# ─── Zsh Plugins ──────────────────────────────────────────────────────────────
section "Zsh plugins"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  info "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions" >> "$LOG" 2>&1
  log "zsh-autosuggestions"
else
  log "zsh-autosuggestions already present"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  info "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" >> "$LOG" 2>&1
  log "zsh-syntax-highlighting"
else
  log "zsh-syntax-highlighting already present"
fi

# ─── Powerlevel10k ────────────────────────────────────────────────────────────
section "Powerlevel10k"

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  info "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k" >> "$LOG" 2>&1
  log "Powerlevel10k installed"
else
  log "Powerlevel10k already present"
fi

# ─── Stow dotfiles ────────────────────────────────────────────────────────────
section "Symlinking dotfiles"

cd "$DOTFILES"

_backup_if_exists() {
  local target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local backup="${target}.bak.$(date +%Y%m%d_%H%M%S)"
    mv "$target" "$backup"
    warn "Backed up existing $(basename "$target") → $backup"
  fi
}

for pkg in zsh p10k git .config .assets .emacs.d; do
  if [ -d "$DOTFILES/$pkg" ]; then
    if stow -R "$pkg" >> "$LOG" 2>&1; then
      log "Stowed: $pkg"
    else
      warn "Conflict stowing $pkg — trying with --adopt..."
      stow --adopt -R "$pkg" >> "$LOG" 2>&1 && log "Stowed (adopted): $pkg" || err "Failed to stow: $pkg"
    fi
  else
    warn "Skipped: $pkg (directory not found)"
  fi
done

# ─── Git local config ─────────────────────────────────────────────────────────
section "Git identity"

if [ ! -f "$HOME/.gitconfig.local" ]; then
  info "No ~/.gitconfig.local found — setting up git identity..."
  echo ""
  printf "  Name  [Gabriel Henrique da Silva]: "
  read -r git_name
  git_name="${git_name:-Gabriel Henrique da Silva}"

  printf "  Email [gabriel.silva@mify.com.br]: "
  read -r git_email
  git_email="${git_email:-gabriel.silva@mify.com.br}"

  cat > "$HOME/.gitconfig.local" <<EOF
[user]
	name = $git_name
	email = $git_email
EOF
  log "Created ~/.gitconfig.local"
else
  log "~/.gitconfig.local already exists"
fi

# ─── Default shell ────────────────────────────────────────────────────────────
section "Default shell"

ZSH_PATH="$(which zsh)"
if [ "$SHELL" != "$ZSH_PATH" ]; then
  info "Setting zsh as default shell..."
  chsh -s "$ZSH_PATH" >> "$LOG" 2>&1
  log "Default shell → zsh"
else
  log "zsh is already the default shell"
fi

# ─── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${GREEN}"
echo "┌────────────────────────────────┐"
echo "│       Setup complete! ✓        │"
echo "└────────────────────────────────┘"
echo -e "${RESET}📋 Log: ${BLUE}$LOG${RESET}"
echo -e "💡 Run: ${BOLD}exec zsh${RESET}"
echo ""
