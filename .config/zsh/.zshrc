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

## Powerline10k
# This is also loaded near the top to enable the "instant prompt" feature.
# To customize prompt, run `p10k configure` or edit .p10k.zsh.
[[ ! -f ${ZDOTDIR}/.p10k.zsh ]] || source ${ZDOTDIR}/.p10k.zsh

# Setup PATH with extra directories

# Add homebrew installed binaries to path
if [[ -f "/opt/homebrew/bin/brew" ]] then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Add Mason-nvim installed binaries to path
if [[ -d "${XDG_DATA_HOME}/nvim/mason/bin" ]] then
    export PATH="${XDG_DATA_HOME}/nvim/mason/bin:${PATH}"
fi

export NVM_DIR="${XDG_CONFIG_HOME}/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

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
