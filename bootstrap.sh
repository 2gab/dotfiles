#!/bin/bash

set -euo pipefail

REPO="https://github.com/2gab/dotfiles.git"
DEST="$HOME/.dotfiles"

echo ""
echo "┌────────────────────────────────┐"
echo "│      dotfiles bootstrap        │"
echo "└────────────────────────────────┘"
echo ""

# Install git if missing
if ! command -v git >/dev/null 2>&1; then
  echo "→ Installing git..."
  if command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --noconfirm git
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get install -y git
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y git
  else
    echo "✗ Instale git manualmente e re-execute"; exit 1
  fi
fi

# Clone or update
if [ -d "$DEST/.git" ]; then
  echo "→ Updating existing dotfiles..."
  git -C "$DEST" pull
else
  echo "→ Cloning dotfiles into $DEST..."
  git clone "$REPO" "$DEST"
fi

echo "→ Running install.sh..."
bash "$DEST/install.sh"
