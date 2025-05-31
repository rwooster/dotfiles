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
#zinit light zsh-users/zsh-autosuggestions

###
### Plugin Configuration
###

## zsh-completions
# Load completions 
autoload -Uz compinit && compinit

# Enable various "completers":
# _extensions - Complete the glob *. with the possible file extensions.
# _complete - This is the main completer we need to use for our completion.
# _approximate - This one is similar to _complete, except that it will try to correct what you’ve typed already (the context) if no match is found.
zstyle ':completion:*' completer _extensions _complete _approximate

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/.zcompcache"

# Make autocompletion case-insensisitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Make completion results use the same colors as ls
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"

# Enable completion menu
zstyle ':completion:*' menu select 

# Color the descriptions in the completion menu.
zstyle ':completion:*:*:*:*:descriptions' format '%F{8}-- %d --%f'

# Put each group descriptor over its corresponding group, rather than all at the top.
zstyle ':completion:*' group-name ''

# Use vi style navigation inside the completion menu
# Note: This doesn't work great currently for vertical lists
# Since the keybind "jj" to exit insert mode interferes.
# TODO: Consider how to handle that.
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

setopt LIST_PACKED
setopt AUTO_LIST
setopt AUTO_MENU

## zsh-autosuggestions
# Set `$` to accept suggestion - vim-like end of line keybind.
#bindkey '$' autosuggest-accept
