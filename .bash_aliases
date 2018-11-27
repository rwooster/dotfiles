alias vi="vim"
alias v="vim"
alias ccheck="clang++-7 $(python ~/.ycm_extra_conf.py)"
alias cformat="pushd /home/ryanwooster/driving/src/ > /dev/null && git diff --name-only --relative HEAD | xargs ./clang_format.sh && popd > /dev/null"
