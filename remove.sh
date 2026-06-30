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
LOG="$DOTFILES/remove.log"

log()     { echo -e "${GREEN}✓${RESET} $1" | tee -a "$LOG"; }
warn()    { echo -e "${YELLOW}⚠${RESET} $1" | tee -a "$LOG"; }
info()    { echo -e "${BLUE}→${RESET} $1" | tee -a "$LOG"; }
err()     { echo -e "${RED}✗${RESET} $1" | tee -a "$LOG"; }
section() { echo -e "\n${BOLD}${CYAN}── $1 ──${RESET}" | tee -a "$LOG"; }

confirm() {
  local msg="$1"
  printf "${YELLOW}?${RESET} $msg [y/N] "
  read -r answer
  [[ "$answer" =~ ^[Yy]$ ]]
}

# ─── Flags ────────────────────────────────────────────────────────────────────
FULL=false
YES=false

for arg in "$@"; do
  case "$arg" in
    --full)   FULL=true ;;
    --yes|-y) YES=true ;;
  esac
done

# ─── Init ─────────────────────────────────────────────────────────────────────
echo "Remove started at $(date)" > "$LOG"

echo -e "${BOLD}${RED}"
echo "┌────────────────────────────────┐"
echo "│    dotfiles remove v1.0        │"
echo "└────────────────────────────────┘"
echo -e "${RESET}📂 ${BLUE}$DOTFILES${RESET}"
echo ""
echo -e "Modo: ${BOLD}$([ "$FULL" = true ] && echo "FULL (remove OMZ, nvm, plugins)" || echo "symlinks only")${RESET}"
echo ""

if ! $YES; then
  confirm "Continuar com a remoção?" || { echo "Abortado."; exit 0; }
fi

# ─── Unstow dotfiles ──────────────────────────────────────────────────────────
section "Removendo symlinks (stow -D)"

cd "$DOTFILES"

for pkg in zsh p10k git config assets emacs; do
  if [ -d "$DOTFILES/$pkg" ]; then
    if stow -D "$pkg" >> "$LOG" 2>&1; then
      log "Unstowed: $pkg"
    else
      warn "Falha ao unstow $pkg (pode já ter sido removido)"
    fi
  else
    warn "Pacote não encontrado, pulando: $pkg"
  fi
done

# ─── gitconfig.local ──────────────────────────────────────────────────────────
section "Git local config"

if [ -f "$HOME/.gitconfig.local" ]; then
  if $YES || confirm "Remover ~/.gitconfig.local?"; then
    rm -f "$HOME/.gitconfig.local"
    log "Removido: ~/.gitconfig.local"
  else
    warn "Mantido: ~/.gitconfig.local"
  fi
else
  info "~/.gitconfig.local não encontrado"
fi

# ─── Full removal (Oh My Zsh, plugins, nvm) ───────────────────────────────────
if $FULL; then

  section "Powerlevel10k"
  if [ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    rm -rf "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
    log "Removido: powerlevel10k"
  else
    info "powerlevel10k não encontrado"
  fi

  section "Zsh plugins"
  for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    local_path="$HOME/.oh-my-zsh/custom/plugins/$plugin"
    if [ -d "$local_path" ]; then
      rm -rf "$local_path"
      log "Removido: $plugin"
    else
      info "$plugin não encontrado"
    fi
  done

  section "Oh My Zsh"
  if [ -d "$HOME/.oh-my-zsh" ]; then
    if $YES || confirm "Remover Oh My Zsh (~/.oh-my-zsh)?"; then
      # usa o script oficial se existir, senão remove na força
      if [ -f "$HOME/.oh-my-zsh/tools/uninstall.sh" ]; then
        env ZSH="$HOME/.oh-my-zsh" bash "$HOME/.oh-my-zsh/tools/uninstall.sh" --unattended >> "$LOG" 2>&1 || true
      else
        rm -rf "$HOME/.oh-my-zsh"
      fi
      log "Removido: Oh My Zsh"
    else
      warn "Mantido: Oh My Zsh"
    fi
  else
    info "Oh My Zsh não encontrado"
  fi

  section "nvm"
  if [ -d "$HOME/.nvm" ]; then
    if $YES || confirm "Remover nvm (~/.nvm)? Isso remove todos os Nodes instalados via nvm."; then
      rm -rf "$HOME/.nvm"
      log "Removido: nvm"
    else
      warn "Mantido: nvm"
    fi
  else
    info "nvm não encontrado"
  fi

fi

# ─── Shell padrão ─────────────────────────────────────────────────────────────
section "Shell padrão"

CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"
ZSH_PATH="$(command -v zsh 2>/dev/null || true)"

if [ -n "$ZSH_PATH" ] && [ "$CURRENT_SHELL" = "$ZSH_PATH" ]; then
  if $YES || confirm "Reverter shell padrão para bash?"; then
    BASH_PATH="$(command -v bash)"
    chsh -s "$BASH_PATH" >> "$LOG" 2>&1
    log "Shell padrão → bash"
  else
    warn "Shell padrão mantido como zsh"
  fi
else
  info "Shell já não é zsh (ou zsh não encontrado)"
fi

# ─── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${GREEN}"
echo "┌────────────────────────────────┐"
echo "│       Remoção concluída! ✓     │"
echo "└────────────────────────────────┘"
echo -e "${RESET}📋 Log: ${BLUE}$LOG${RESET}"
if ! $FULL; then
  echo -e "💡 Para remover também OMZ, nvm e plugins: ${BOLD}./remove.sh --full${RESET}"
fi
echo ""
