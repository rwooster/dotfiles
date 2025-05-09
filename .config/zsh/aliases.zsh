alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias ls="ls --color=auto"
alias ll="ls -la"
alias gitfix='git commit --amend --no-edit'

# Quickly open config files
alias al="nvim ~/.config/zsh/aliases.zsh"
alias rc="nvim ~/.config/zsh/.zshrc"
alias term="nvim ~/.config/alacritty/alacritty.toml"
alias load="source ~/.config/zsh/.zshrc"

# Useful functions
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
