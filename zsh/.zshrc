# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

DOTFILES="${${(%):-%x}:A:h:h}"

# Load exports (ZSH path, NVM, env vars)
source "$DOTFILES/zsh/exports.zsh"

# Theme and plugins (must be defined before sourcing OMZ)
ZSH_THEME="powerlevel10k/powerlevel10k"
source "$DOTFILES/zsh/plugins.zsh"

# Load Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

# Load custom configuration (after OMZ)
source "$DOTFILES/zsh/aliases.zsh"
source "$DOTFILES/zsh/functions.zsh"

# Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
