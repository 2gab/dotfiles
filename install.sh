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

# ─── Distro detection ─────────────────────────────────────────────────────────
detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
      arch|manjaro|endeavouros) DISTRO="arch" ;;
      debian|ubuntu|pop|linuxmint) DISTRO="debian" ;;
      *) DISTRO="unknown" ;;
    esac
  else
    DISTRO="unknown"
  fi
}

pkg_install() {
  case "$DISTRO" in
    arch)
      if command -v yay >/dev/null 2>&1; then
        yay -S --needed --noconfirm "$@"
      else
        sudo pacman -S --needed --noconfirm "$@"
      fi
      ;;
    debian)
      sudo apt-get install -y "$@"
      ;;
    *)
      warn "Distro não suportada — pulando pacotes"
      ;;
  esac
}

get_packages() {
  case "$DISTRO" in
    arch)
      echo "zsh stow kitty i3-wm i3status picom feh neovim emacs poppler-glib pandoc-cli ttf-jetbrains-mono-nerd eza bat ripgrep fd tmux docker docker-compose dex xdotool maim xclip xss-lock i3lock network-manager-applet dmenu direnv autorandr"
      ;;
    debian)
      # A Nerd Font não tem pacote no Debian — ver install_nerd_font.
      # cmake..libvterm-dev: vterm; autoconf..zlib1g-dev: epdfinfo do pdf-tools.
      echo "zsh stow kitty i3 i3status picom feh neovim emacs libpoppler-glib-dev libpoppler-private-dev pandoc eza bat ripgrep fd-find tmux docker.io docker-compose dex xdotool maim xclip xss-lock i3lock network-manager-gnome suckless-tools direnv autorandr pulseaudio-utils psmisc xz-utils build-essential cmake libtool-bin libvterm-dev autoconf automake pkg-config libpng-dev zlib1g-dev"
      ;;
  esac
}

detect_distro

log()    { echo -e "${GREEN}✓${RESET} $1" | tee -a "$LOG"; }
warn()   { echo -e "${YELLOW}⚠${RESET} $1" | tee -a "$LOG"; }
info()   { echo -e "${BLUE}→${RESET} $1" | tee -a "$LOG"; }
err()    { echo -e "${RED}✗${RESET} $1" | tee -a "$LOG"; }
section(){ echo -e "\n${BOLD}${CYAN}── $1 ──${RESET}" | tee -a "$LOG"; }

# ─── Init ─────────────────────────────────────────────────────────────────────
echo "Bootstrap started at $(date)" > "$LOG"
FAILED=0

echo -e "${BOLD}${CYAN}"
echo "┌────────────────────────────────┐"
echo "│    dotfiles bootstrap v2.0     │"
echo "└────────────────────────────────┘"
echo -e "${RESET}📂 ${BLUE}$DOTFILES${RESET}"
echo -e "🐧 ${BLUE}distro: $DISTRO${RESET}"
echo ""

# ─── Dependencies ─────────────────────────────────────────────────────────────
section "Dependencies"

require_cmds() {
  local cmd
  for cmd in "$@"; do
    if command -v "$cmd" >/dev/null 2>&1; then
      log "$cmd"
    else
      err "Missing: $cmd — install it first and re-run"
      exit 1
    fi
  done
}

# Debian instala o binário com outro nome (fdfind, batcat)
link_debian_bin() {
  local real="$1" name="$2"
  if command -v "$real" >/dev/null 2>&1 && ! command -v "$name" >/dev/null 2>&1; then
    sudo ln -sf "$(command -v "$real")" "/usr/local/bin/$name"
    log "Symlink $name → $real criado"
  fi
}

install_nerd_font() {
  local dir="$HOME/.local/share/fonts/JetBrainsMonoNerd" tmp
  if fc-list 2>/dev/null | grep -q "JetBrainsMono Nerd Font"; then
    log "JetBrainsMono Nerd Font já presente"
    return
  fi
  info "Instalando JetBrainsMono Nerd Font..."
  tmp="$(mktemp -d)"
  if curl -fsSL -o "$tmp/font.tar.xz" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz \
    && mkdir -p "$dir" \
    && tar xJf "$tmp/font.tar.xz" -C "$dir"; then
    fc-cache -f "$dir" >> "$LOG" 2>&1 || true
    log "JetBrainsMono Nerd Font instalada"
  else
    err "Falha ao instalar a Nerd Font"
    FAILED=1
  fi
  rm -rf "$tmp"
}

# stow e zsh vêm da lista de pacotes e são checados depois dela
require_cmds git curl

# ─── Packages ─────────────────────────────────────────────────────────────────
section "System packages"

if [ "$DISTRO" = "unknown" ]; then
  warn "Distro não reconhecida — pulando instalação de pacotes"
else
  if [ "$DISTRO" = "debian" ]; then
    sudo apt-get update -qq >> "$LOG" 2>&1 || warn "apt-get update falhou (veja $LOG)"
  fi
  read -ra PACKAGES <<< "$(get_packages)"
  if pkg_install "${PACKAGES[@]}" >> "$LOG" 2>&1; then
    log "Pacotes instalados"
  else
    err "Falha ao instalar pacotes (veja $LOG)"
    FAILED=1
  fi

  if [ "$DISTRO" = "debian" ]; then
    link_debian_bin fdfind fd
    link_debian_bin batcat bat
    install_nerd_font
  fi

  # Docker sem sudo (vale após sair e entrar na sessão)
  if getent group docker >/dev/null && ! id -nG "$USER" | grep -qw docker; then
    sudo usermod -aG docker "$USER"
    log "$USER adicionado ao grupo docker"
  fi
fi

require_cmds stow zsh

# nvm não é pacote — instala via curl em qualquer distro
# NVM_DIR explícito: com XDG_CONFIG_HOME definido (ex.: XFCE) o instalador usaria
# ~/.config/nvm, mas o exports.zsh carrega de ~/.nvm
if [ ! -s "$HOME/.nvm/nvm.sh" ]; then
  info "Instalando nvm..."
  mkdir -p "$HOME/.nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | NVM_DIR="$HOME/.nvm" bash >> "$LOG" 2>&1
  log "nvm instalado"
else
  log "nvm já presente"
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

# Move para o lado os arquivos reais que o pacote vai substituir. Não usar
# stow --adopt: ele sobrescreve o arquivo do repositório com o que está no $HOME
# (o instalador do Oh My Zsh cria um ~/.zshrc, que tomaria o lugar do nosso).
_backup_conflicts() {
  local pkg="$1" rel ignore="$DOTFILES/$1/.stow-local-ignore"
  while IFS= read -r -d '' rel; do
    rel="${rel#./}"
    [ "$rel" = ".stow-local-ignore" ] && continue
    if [ -f "$ignore" ] && printf '%s\n' "$rel" | grep -qEf "$ignore"; then
      continue
    fi
    _backup_if_exists "$HOME/$rel"
  done < <(cd "$DOTFILES/$pkg" && find . \( -type f -o -type l \) -print0)
}

for pkg in zsh p10k git config assets emacs tmux; do
  if [ -d "$DOTFILES/$pkg" ]; then
    stow -n -t "$HOME" -R "$pkg" >> "$LOG" 2>&1 || _backup_conflicts "$pkg"
    if stow -t "$HOME" -R "$pkg" >> "$LOG" 2>&1; then
      log "Stowed: $pkg"
    else
      err "Failed to stow: $pkg (veja $LOG)"
      FAILED=1
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
  # Sem valores padrão: este repositório é público
  printf "  Name: "
  read -r git_name
  printf "  Email (privado: ID+usuario@users.noreply.github.com): "
  read -r git_email

  if [ -n "$git_name" ] && [ -n "$git_email" ]; then
    cat > "$HOME/.gitconfig.local" <<EOF
[user]
	name = $git_name
	email = $git_email
EOF
    log "Created ~/.gitconfig.local"
  else
    warn "Nome ou email vazio — ~/.gitconfig.local não foi criado"
  fi
else
  log "~/.gitconfig.local already exists"
fi

# ─── Default shell ────────────────────────────────────────────────────────────
section "Default shell"

ZSH_PATH="$(command -v zsh)"
# $SHELL só muda após novo login; o valor real está no passwd
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$ZSH_PATH" ]; then
  info "Setting zsh as default shell..."
  # Sem redirecionar: o chsh pede a senha no terminal
  if chsh -s "$ZSH_PATH"; then
    log "Default shell → zsh"
  else
    err "chsh falhou — rode: chsh -s $ZSH_PATH"
    FAILED=1
  fi
else
  log "zsh is already the default shell"
fi

# ─── Done ─────────────────────────────────────────────────────────────────────
if [ "$FAILED" -ne 0 ]; then
  echo ""
  err "Setup incompleto — veja os erros acima e $LOG"
  exit 1
fi

echo ""
echo -e "${BOLD}${GREEN}"
echo "┌────────────────────────────────┐"
echo "│       Setup complete! ✓        │"
echo "└────────────────────────────────┘"
echo -e "${RESET}📋 Log: ${BLUE}$LOG${RESET}"
echo -e "💡 Run: ${BOLD}exec zsh${RESET}"
echo ""
