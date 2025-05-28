###
### Styling via zstyle
###

# Make autocompletion case-insensisitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Make completion results use the same colors as ls
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Remove the underline that zsh-syntax-highlighting adds
# https://github.com/zsh-users/zsh-syntax-highlighting/issues/573#issuecomment-434918934
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
ZSH_HIGHLIGHT_STYLES[precommand]=none
ZSH_HIGHLIGHT_STYLES[suffix-alias]=none
ZSH_HIGHLIGHT_STYLES[autodirectory]=none
