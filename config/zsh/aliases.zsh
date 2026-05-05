alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias vimdiff="nvim -d"
alias tmux="tmux -f ${XDG_CONFIG_HOME}/tmux/tmux.conf" # Support pre-3.1 tmux
alias tm="tmux"
alias ls="ls --color=auto"
alias ll="ls -la"
alias gitfix='git commit --amend --no-edit'
alias stylua="stylua --indent-type Spaces"

# Quickly open config files
alias zal="nvim ~/.config/zsh/aliases.zsh"
alias zrc="nvim ~/.config/zsh/.zshrc"
alias tmc="nvim ~/.config/tmux/tmux.conf"
alias alc="nvim ~/.config/alacritty/alacritty.toml"
alias vrc="nvim ~/.config/nvim/init.lua"
alias gitrc="nvim ~/.config/git/config"

# Git command aliases
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gch="git checkout"
alias gb="git branch"
# Hide the "+" and "-" by default and rely on colors.
alias gd="git diff --output-indicator-new=' ' --output-indicator-old=' '"
# Add a "verbose" mode which includes the indictors if needed.
alias gdv="git diff"
alias gds="gd --staged"
alias gcl="git clone"
alias gpu="git push"
alias gpl="git pull"
alias grt="git restore"
alias grts="git restore --staged"
alias gm="git merge"
alias gr="git rebase"
alias gf="git fetch"
alias gst="git stash"
alias grs="git reset"

# Format guide:
# %C Set color
# %h commit hash
# %an author name
# %ar commit time (relative)
# %D refs
# %n newline
# %s commit message
# TODO: Get a common definition for colors
alias gl="git log --graph --pretty=format:'%C(11)%h %C(10)%an%C(8) <%ar> %C(4)%D%n%s%n'"

# Reload the .zsh config file
alias rld="source ~/.config/zsh/.zshrc"

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
    fzf --preview="git log {}" --height 20% --bind=ctrl-z:ignore |
    xargs_no_run_if_empty git checkout
}
alias ch="checkout"

delete-branches() {
  git branch |
    rg --invert-match '\*' |
    cut -c 3- |
    fzf --multi --preview="git log {}" --height 20% --bind=ctrl-z:ignore |
    xargs_no_run_if_empty git branch --delete --force
}

git_add_fuzzy() {
  git ls-files -m -o --exclude-standard |
    fzf --multi --preview="git diff {}" --height 40% --bind=ctrl-z:ignore |
    xargs_no_run_if_empty git add
}
alias gaf="git_add_fuzzy"

git_worktree_add() {
  local repo_root repo_name parent_dir branch summary worktree_path
  repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "Not in a git repository" >&2
    return 1
  }
  repo_name=$(basename "$repo_root")
  parent_dir=$(dirname "$repo_root")

  branch=$(
    git branch --all |
      rg --invert-match '\*|HEAD' |
      cut -c 3- |
      sed 's|^remotes/[^/]*/||' |
      awk '!seen[$0]++' |
      fzf --preview="git log {}" --height 40% --bind=ctrl-z:ignore
  )

  [[ -z "$branch" ]] && return 1

  summary="${branch##*/}"
  summary="${summary//_/-}"
  worktree_path="${parent_dir}/${repo_name}-${summary}"

  git worktree add "$worktree_path" "$branch"
}
alias gwt="git_worktree_add"

git_worktree_remove() {
  local current
  current=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "Not in a git repository" >&2
    return 1
  }

  git worktree list --porcelain |
    rg '^worktree ' |
    cut -d' ' -f2- |
    rg --invert-match "^${current}$" |
    awk -F/ '{print $NF "\t" $0}' |
    fzf --multi \
      --with-nth=1 \
      --delimiter='\t' \
      --preview="git -C {2} log --oneline -20" \
      --height 40% \
      --bind=ctrl-z:ignore |
    cut -f2 |
    xargs_no_run_if_empty -I{} git worktree remove {}
}
alias gwtr="git_worktree_remove"


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
    sed -e 's/^"//' -e 's/"$//' -e 's/\\t/\t/' |
    fzf \
      --with-nth=1 \
      --delimiter='\t' \
      --preview='echo -e {2}' \
      --bind=ctrl-z:ignore |
    cut -d' ' -f1 | tr -d '#'
  )

  if [ -n "$pr_number" ]; then
    gh pr checkout "$pr_number"
  fi
}
