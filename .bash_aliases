alias vi="vim"
alias v="vim"
alias ccheck='clang++-7 $(python ~/.ycm_extra_conf.py)'
alias cformat='pushd /home/ryanwooster/driving/src/ > /dev/null && git diff --name-only --relative HEAD | egrep "*.[cc|h]$" | xargs ./clang_format.sh && popd > /dev/null'
alias fzf='fzf-tmux'

cgrep() {
  grep "$@" * -riIn --exclude-dir=".git" --exclude-dir="bazel-*" --exclude-dir="automated_data_review" --exclude="tags" 2>/dev/null
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  local out file key
  IFS=$'\n' out=($(fzf --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || vim "${file}"
  fi
}

# cdf - cd into the directory of the selected file
fcd() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}
