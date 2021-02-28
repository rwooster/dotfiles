# Setup fzf
# ---------
if [[ ! "$PATH" == */home/ryanwooster/.fzf/bin* ]]; then
  export PATH="$PATH:/home/ryanwooster/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/ryanwooster/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/ryanwooster/.fzf/shell/key-bindings.bash"

