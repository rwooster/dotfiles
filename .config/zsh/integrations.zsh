###
### Shell integrations
###

# Enable fzf
eval "$(fzf --zsh)"

# Configure fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND='fd --type file --follow --color=always --exclude bin/'
# This lets the fd colors work. This can be slow, remove this if fzf seems to start lagging.
export FZF_DEFAULT_OPTS="--ansi"
export FZF_CTRL_T_COMMAND='fd --follow --strip-cwd-prefix --color=always --exclude bin/'
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
