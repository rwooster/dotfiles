VISUAL=vim
EDITOR=vim

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt share_history autocd extendedglob nomatch
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
export PROMPT='${COLOR_USR}%n ${COLOR_DIR}%3~ ${COLOR_GIT}$(__git_ps1 "(%s)")${COLOR_DEF}$ '

# Set driving variables
export BAZEL_ENABLE_DOCKER_SANDBOX=true
export DRIVING_BAZEL_REMOTE_CACHE=s3
export DISPLAY=:1

# Set aliases
# TODO: Move these to a separate file.
# Also should port over some of the useful functions from the bash config as needed.
export DRIVING_ROOT="/home/ryan-wooster/driving"
alias vi="vim"
alias v="vim"
alias gitfix='git commit --amend --no-edit'
alias ls="ls --color=auto"
alias tmux="tmux -f ~/.config/tmux/tmux.conf"
# Emulate macos version
alias pbcopy="xclip -sel clip"
alias dr="${DRIVING_ROOT}/src/os_image/docker_run.py"

buildifier() {
  pushd ${DRIVING_ROOT}
  ./src/bazel-bin/tools/buildifier_detail --mode="fix" --lint="fix" --warnings=native-py $(git diff master --name-only | rg BUILD)
  popd
}

# Configure fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type file --follow --color=always --exclude bin/'
# This lets the fd colors work. This can be slow, remove this if fzf seems to start lagging.
export FZF_DEFAULT_OPTS="--ansi"
export FZF_CTRL_T_COMMAND='fd --follow --strip-cwd-prefix --color=always --exclude bin/'
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

# - The first argument to the function ($1) is the base path to start traversal
_fzf_compgen_path() {
  fd --follow --color=always --exclude bin/ . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --follow --color=always --exclude bin/ --type d  . "$1"
}

xargs_no_run_if_empty() {
  # On MacOS, xargs default behavior is `--no-run-if-empty`,
  # and that parameter is not accepted. On linux, the parameter
  # needs to be passed in.

  MAYBE_NO_RUN_IF_EMPTY=""
  if [[ "${uname_out}" == "Linux" ]]; then
    MAYBE_NO_RUN_IF_EMPTY="--no-run-if-empty"
  fi

  xargs ${MAYBE_NO_RUN_IF_EMPTY} "$@"
}

checkout() {
  git branch |
    rg --invert-match '\*' |
    cut -c 3- |
    fzf --preview="git log {}" |
    xargs_no_run_if_empty git checkout
}
alias ch="checkout"

delete-branches() {
  git branch |
    rg --invert-match '\*' |
    cut -c 3- |
    fzf --multi --preview="git log {}" |
    xargs_no_run_if_empty git branch --delete --force
}

pr-checkout() {
  local jq_template pr_number

  jq_template='"'\
'#\(.number) - \(.title)'\
'\t'\
'Author: \(.user.login)\n'\
'Created: \(.created_at)\n'\
'Updated: \(.updated_at)\n\n'\
'\(.body)'\
'"'

  pr_number=$(
    gh api 'repos/:owner/:repo/pulls' |
    jq ".[] | $jq_template" |
    sed -e 's/"\(.*\)"/\1/' -e 's/\\t/\t/' |
    fzf \
      --with-nth=1 \
      --delimiter='\t' \
      --preview='echo -e {2}' \
      --preview-window=top:wrap |
    sed 's/^#\([0-9]\+\).*/\1/'
  )

  if [ -n "$pr_number" ]; then
    gh pr checkout "$pr_number"
  fi
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH=/home/ryan-wooster/.local/bin:$PATH
export PATH=$PATH:/opt/tri/llvm/11.1.0/bin
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

if [ -e /home/ryan-wooster/.nix-profile/etc/profile.d/nix.sh ]; then . /home/ryan-wooster/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
eval "$(/home/ryan-wooster/.nix-profile/bin/direnv hook zsh)"
