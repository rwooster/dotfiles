###
### Styling via zstyle
###

# Remove the underline that zsh-syntax-highlighting adds
# https://github.com/zsh-users/zsh-syntax-highlighting/issues/573#issuecomment-434918934
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
ZSH_HIGHLIGHT_STYLES[precommand]=none
ZSH_HIGHLIGHT_STYLES[suffix-alias]=none
ZSH_HIGHLIGHT_STYLES[autodirectory]=none
