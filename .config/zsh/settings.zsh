###
### General settings
###

export VISUAL=nvim
export EDITOR=nvim

# History
HISTSIZE=100000
SAVEHIST=$HISTSIZE
HISTFILE=${XDG_DATA_HOME}/zsh/.zsh_history
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

if [[ ! -f "${HISTFILE}" ]]; then
    mkdir -p ${XDG_DATA_HOME}/zsh/
    touch ${HISTFILE}
fi
