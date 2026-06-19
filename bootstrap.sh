#!/bin/bash

set -euo pipefail

REPO="https://github.com/gabrhsilva/dotfiles.git"
DEST="$HOME/.dotfiles"

echo ""
echo "┌────────────────────────────────┐"
echo "│      dotfiles bootstrap        │"
echo "└────────────────────────────────┘"
echo ""

# Install git if missing (Arch Linux)
if ! command -v git >/dev/null 2>&1; then
  echo "→ Installing git..."
  sudo pacman -S --noconfirm git
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
