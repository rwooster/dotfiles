VISUAL=vim
EDITOR=vim

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory autocd extendedglob nomatch 
setopt NO_AUTOLIST BASH_AUTOLIST NO_MENUCOMPLETE
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
bindkey "^R" history-incremental-pattern-search-backward

# The following lines were added by compinstall
zstyle :compinstall filename '/home/ubuntu/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
