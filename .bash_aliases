DRIVING_ROOT="/home/ryanwooster/driving"

alias vi="vim"
alias v="vim"
alias ccheck='clang++-8 $(python ~/.ycm_extra_conf.py)'
alias cformat='pushd /home/ryanwooster/driving/src/ > /dev/null && git diff --name-only --relative HEAD | egrep "*.[cc|h]$" | xargs ./clang_format.sh && popd > /dev/null'
alias fzf='fzf-tmux'
alias te='${DRIVING_ROOT}/src/program/timing_measurement/timing_eval.py -b ${DRIVING_ROOT}/src/interface/timing_measurement/budget_data/planner_timing.yaml -i'
alias tpg='${DRIVING_ROOT}/src/program/timing_measurement/timing_eval.py -b ${DRIVING_ROOT}/src/interface/timing_measurement/budget_data/problem_generator_timing.yaml -i'
alias t2c='${DRIVING_ROOT}/src/program/tracing/trace2chrome.py'
alias gitfix='git commit --amend --no-edit'
alias x="${DRIVING_ROOT}/bin/x_view"
alias xst='x ${DRIVING_ROOT}/build/logs/system-test-latest/d001/*.tlog'
alias clip="xclip -sel clip"
alias st="${DRIVING_ROOT}/src/test/system_test/system_test.py"

play() {
  ${DRIVING_ROOT}/src/utils/find_log.py "$@" | xargs ${DRIVING_ROOT}/bin/x_view
}

cgrep() {
  grep "$@" * -riIn --exclude-dir=".git" --exclude-dir="bazel-*" --exclude-dir="automated_data_review" --exclude="tags" --exclude-dir="third_party" 2>/dev/null
}

crg() {
  rg -g '!*.json' -g '!automated_data_review' -g '!bazel-*' "$@" 
}

to_s3() {
  aws s3 cp "${1}" "s3://scratch-tri-global/ryan.wooster/${2}"
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
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && pushd "$dir"
}

github_url() {
  base="https://github.awsinternal.tri.global/driving/driving/tree/master/src"

  echo "${base}/${1}"
}

xsimian() {
  TLOG=$(ls -td ~/driving/build/simian-output/simulation/*/ | head -1)
  TLOG="${TLOG}/customer_output/debug.tlog"
  echo $TLOG
  ~/driving/bin/x_view $TLOG
}

vsimian() {
  FILE=$(ls -t ~/driving/build/simian-output/simulation/*.stderr | head -1)
  vim ${FILE}
}

dep_lookup() {
  HEADER_FILE=${1}

  pushd ${DRIVING_ROOT}/src >/dev/null
  FULLNAME=$(bazel query $HEADER_FILE)
  bazel query "kind(\"cc_.*\", attr('hdrs', $FULLNAME, ${FULLNAME//:*/}:*) union attr('srcs', $FULLNAME, ${FULLNAME//:*/}:*))"
  popd >/dev/null
}


_maybe_custom_file_widget() {
  # We need to catch the potential request for sudo.
  bazel version > /dev/null 2>&1

  case ${READLINE_LINE} in 
    "bazel test ") selected=$(bazel query 'kind("cc_test", //...)' 2> /dev/null | fzf);;
    "bazel build ") selected=$(bazel query //... 2> /dev/null | fzf);;
    "bazel run ") selected=$(bazel query 'kind("cc_binary|cc_test", //...)' 2> /dev/null | fzf);;
    *"system_test.py"*|"st ")
      git_root=$(git rev-parse --show-toplevel)
      selected=$($git_root/src/test/system_test/list.py --format text-name | awk '{print $1}' | cut -d ":" -f1 | fzf)
      ;;
    *) 
      selected=''
      fzf-file-widget
      ;;
  esac

  if [[ -n ${selected} ]]; then
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
  fi
}

if [ $BASH_VERSINFO -gt 3 ]; then
  bind -x '"\C-t": "_maybe_custom_file_widget"'
fi
