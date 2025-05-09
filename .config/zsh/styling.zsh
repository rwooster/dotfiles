###
### Styling via zstyle
###

# Make autocompletion case-insensisitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Make completion results use the same colors as ls
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
