#!/bin/bash

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Symlinks
ln -sf $PWD/zsh/.zshrc ~/.zshrc
ln -sf $PWD/zsh/.p10k.zsh ~/.p10k.zsh
mkdir -p ~/.config/kitty
ln -sf $PWD/kitty/kitty.conf ~/.config/kitty/kitty.conf
