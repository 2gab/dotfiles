# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# NVM
export NVM_DIR="$HOME/.nvm"
if [ -s "/usr/share/nvm/init-nvm.sh" ]; then
    # Arch: nvm instalado via AUR (pacote nvm)
    source "/usr/share/nvm/init-nvm.sh"
elif [ -s "$NVM_DIR/nvm.sh" ]; then
    # Debian e outros: nvm instalado via curl (~/.nvm)
    source "$NVM_DIR/nvm.sh"
fi

# direnv (per-project env vars, e.g. LEDGER_FILE in folio)
eval "$(direnv hook zsh)"
