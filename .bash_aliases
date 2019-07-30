alias vi="vim"
alias v="vim"
alias ccheck='clang++-7 $(python ~/.ycm_extra_conf.py)'
alias cformat='pushd /home/ryanwooster/driving/src/ > /dev/null && git diff --name-only --relative HEAD | egrep "*.[cc|h]$" | xargs ./clang_format.sh && popd > /dev/null'
alias fzf='fzf-tmux'
alias te='/home/ryanwooster/driving/src/interface/timing_measurement/timing_eval.py -b /home/ryanwooster/driving/src/interface/timing_measurement/budget_data/planner_timing.yaml -i'

cgrep() {
  grep "$@" * -riIn --exclude-dir=".git" --exclude-dir="bazel-*" --exclude-dir="automated_data_review" --exclude="tags" 2>/dev/null
}

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fo() {
  local files=$(fzf --query="$1" --multi --select-1 --exit-0)
  [[ -n "$files" ]] && vim "${files[@]}"
}

# cdf - cd into the directory of the selected file
fcd() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}
