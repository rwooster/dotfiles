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
  local repo_root repo_name parent_dir branch summary worktree_path new_branch
  repo_root=$(git worktree list --porcelain 2>/dev/null | awk '/^worktree / {print $2; exit}')
  [[ -z "$repo_root" ]] && {
    echo "Not in a git repository" >&2
    return 1
  }
  repo_name=$(basename "$repo_root")
  parent_dir=$(dirname "$repo_root")

  if [[ -n "$1" ]]; then
    # Explicit branch name given: create a new branch for it.
    branch="$1"
    new_branch=1
  else
    # No argument: pick an existing branch, or type a new name to create it.
    # --print-query makes fzf emit the typed query as the first line, followed
    # by the selection (if any). No selection => the query is a new branch name.
    local fzf_out query selected
    fzf_out=$(
      git branch |
        rg --invert-match '\*|HEAD' |
        cut -c 3- |
        fzf --print-query --preview="git log {}" --height 40% --bind=ctrl-z:ignore
    )
    query=${fzf_out%%$'\n'*}
    if [[ "$fzf_out" == *$'\n'* ]]; then
      selected=${fzf_out#*$'\n'}
    else
      selected=""
    fi
    if [[ -n "$selected" ]]; then
      branch="$selected"
    elif [[ -n "$query" ]]; then
      branch="$query"
      new_branch=1
    else
      return 1
    fi
  fi

  summary="${branch##*/}"
  summary="${summary//_/-}"
  worktree_path="${parent_dir}/${repo_name}-${summary}"

  if [[ -n "$new_branch" ]]; then
    git worktree add -b "$branch" "$worktree_path" || return 1
  else
    git worktree add "$worktree_path" "$branch" || return 1
  fi

  cd "$worktree_path"
}
alias gwt="git_worktree_add"

git_worktree_remove() {
  local current main_worktree selected
  current=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "Not in a git repository" >&2
    return 1
  }
  # The first worktree listed is the main checkout; never offer it for removal.
  main_worktree=$(git worktree list --porcelain | awk '/^worktree / {print $2; exit}')

  selected=$(
    git worktree list --porcelain |
      rg '^worktree ' |
      cut -d' ' -f2- |
      rg --invert-match "^${main_worktree}$" |
      awk -F/ '{print $NF "\t" $0}' |
      fzf --multi \
        --with-nth=1 \
        --delimiter='\t' \
        --preview="git -C {2} log --oneline -20" \
        --height 40% \
        --bind=ctrl-z:ignore |
      cut -f2
  )
  [[ -z "$selected" ]] && return 1

  # If the worktree we're currently in is being removed, cd out first so the
  # remove succeeds, then land in the main checkout.
  if print -r -- "$selected" | rg --quiet "^${current}$"; then
    removed_current=1
    cd "$main_worktree"
  fi

  print -r -- "$selected" | xargs_no_run_if_empty -I{} git worktree remove {}
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
