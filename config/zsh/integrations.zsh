###
### Shell integrations
###

# Enable fzf
eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND='fd --type file --follow --color=always --exclude bin/ -H'
# This lets the fd colors work. This can be slow, remove this if fzf seems to start lagging.
export FZF_DEFAULT_OPTS="--ansi"
export FZF_CTRL_T_COMMAND='fd --follow --strip-cwd-prefix --color=always --exclude bin/ -H'
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

# - The first argument to the function ($1) is the base path to start traversal
_fzf_compgen_path() {
  fd --follow --color=always --exclude bin/ . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --follow --color=always --exclude bin/ --type d  . "$1"
}

_fzf_complete_bazel_test() {
  _fzf_complete '-m' "$@" < <(command bazel query \
    "kind('(test|test_suite) rule', //...)" 2> /dev/null)
}

_fzf_complete_bazel_run() {
  _fzf_complete '-m' "$@" < <(command bazel query \
    "kind('(cc_binary|test|test_suite) rule', //...)" 2> /dev/null)
}

_fzf_complete_bazel() {
  local tokens
  tokens=(${(z)LBUFFER})

  if [ ${#tokens[@]} -ge 3 ] && [ "${tokens[2]}" = "test" ]; then
    _fzf_complete_bazel_test "$@"
  elif [ ${#tokens[@]} -ge 3 ] && [ "${tokens[2]}" = "run" ]; then
    _fzf_complete_bazel_run "$@"
  else
    # Might be able to make this better someday, by listing all repositories
    # that have been configured in a WORKSPACE.
    # See https://stackoverflow.com/questions/46229831/ or just run
    #     bazel query //external:all
    # This is the reason why things like @ruby_2_6//:ruby.tar.gz don't show up
    # in the output: they're not a dep of anything in //..., but they are deps
    # of @ruby_2_6//...
    _fzf_complete '-m' "$@" < <(command bazel query --keep_going \
      --noshow_progress \
      "kind('(binary rule)|(generated file)', deps(//...))" 2> /dev/null)
  fi
}
