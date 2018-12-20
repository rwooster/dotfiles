#!/bin/bash

if [[ ! -e ~/.ycm_extra_conf.py ]]; then
  pushd ~/documents && git clone https://github.awsinternal.tri.global/paul-ozog/ycmd-config && popd
  ln -sf ~/documents/ycmd-config/ycm_extra_conf.py ~/.ycm_extra_conf.py
else
  echo "YCM Conf file already exists"
fi

if [[ ! -e ~/.fzf.bash ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
else
  echo "FZF is already installed."
fi
