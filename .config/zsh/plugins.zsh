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
ZDUMP_LOCATION="${XDG_CACHE_HOME:-$HOME/.cache}"
compinit -d "${ZDUMP_LOCATION}"

## Powerline10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ${ZDOTDIR}/.p10k.zsh ]] || source ${ZDOTDIR}/.p10k.zsh

## zsh-autosuggestions
# Set `$` to accept suggestion - vim-like end of line keybind.
#bindkey '$' autosuggest-accept
