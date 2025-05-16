# Make sure required env variables are set/updated.
if [[ -f "${HOME}/.zshenv" ]] then
    source "${HOME}/.zshenv"
fi

###
### Setup prompt
### 

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Setup PATH with extra directories

# Add homebrew installed binaries to path
if [[ -f "/opt/homebrew/bin/brew" ]] then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Add Mason-nvim installed binaries to path
if [[ -d "${XDG_DATA_HOME}/nvim/mason/bin" ]] then
    export PATH="${XDG_DATA_HOME}/nvim/mason/bin:${PATH}"
fi

export PATH="${XDG_BIN_HOME}:${PATH}"

source "${ZDOTDIR}/plugins.zsh"
source "${ZDOTDIR}/settings.zsh"
source "${ZDOTDIR}/bindings.zsh"
source "${ZDOTDIR}/aliases.zsh"
source "${ZDOTDIR}/styling.zsh"
source "${ZDOTDIR}/integrations.zsh"

if [[ -f "${HOME}/.local_zshrc" ]] then
    source "${HOME}/.local_zshrc"
fi
