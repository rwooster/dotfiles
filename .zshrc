VISUAL=vim
EDITOR=vim

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory autocd extendedglob nomatch 
setopt NO_AUTOLIST BASH_AUTOLIST NO_MENUCOMPLETE
setopt noEXTENDED_GLOB
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/home/ubuntu/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Additional keybindings
# Fix ctrl+R for history reverse search
bindkey "^R" history-incremental-pattern-search-backward

# Set prompt
export GIT_PS1_SHOWDIRTYSTATE=true
source ~/dotfiles/.git-prompt.sh

COLOR_DEF=$'%f'
COLOR_USR=$'%F{243}'
COLOR_DIR=$'%F{197}'
COLOR_GIT=$'%F{39}'
setopt PROMPT_SUBST
export PROMPT='${COLOR_USR}%n ${COLOR_DIR}%6~ ${COLOR_GIT}$(__git_ps1 "(%s)")${COLOR_DEF}$ '

# Set driving variables
export BAZEL_ENABLE_DOCKER_SANDBOX=true
export DRIVING_BAZEL_REMOTE_CACHE=s3
export DISPLAY=:1
export PATH=$PATH:/home/ryanwooster/.arene/bin

# Set aliases
# TODO: Move these to a separate file.
# Also should port over some of the useful functions from the bash config as needed.
alias vi="vim"
alias v="vim"
alias gitfix='git commit --amend --no-edit'
alias ls="ls --color=auto"

# Configure fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type file --follow --color=always'
# This lets the fd colors work. This can be slow, remove this if fzf seems to start lagging.
export FZF_DEFAULT_OPTS="--ansi"
export FZF_CTRL_T_COMMAND='fd --follow --strip-cwd-prefix --color=always'
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
