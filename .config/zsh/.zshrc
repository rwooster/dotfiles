###
### Setup prompt
### 

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

###
### Homebrew setup
### 

# Add homebrew installed binaries to path
if [[ -f "/opt/homebrew/bin/brew" ]] then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

### 
### Setup Zinit plugin manager
###

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

### 
### Load plugins via Zinit
###

# Confusing syntax for loading the Powerlevel10k plugin via zinit. This clones the repo with a depth=1.
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

###
### Plugin Configuration
###

## zsh-completions
# Load completions 
autoload -Uz compinit && compinit

## Powerline10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

## zsh-autosuggestions
# Set `$` to accept suggestion - vim-like end of line keybind.
bindkey '$' autosuggest-accept

###
### General settings
###

# History
HISTSIZE=100000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
VISUAL=nvim
EDITOR=nvim

###
### Keybindings 
###

bindkey -v
bindkey '^r' history-search-backward
#bindkey "^R" history-incremental-pattern-search-backward

###
### Aliases
###
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias ls="ls --color=auto"
alias gitfix='git commit --amend --no-edit'

###
### Styling via zstyle
###

# Make autocompletion case-insensisitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Make completion results use the same colors as ls
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

###
### Shell integrations
###

# Enable fzf
eval "$(fzf --zsh)"
