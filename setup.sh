#!/bin/bash
set -euo pipefail

pushd ~
rm -f .vimrc .tmux.conf .zshrc
ln -s dotfiles/.vimrc .vimrc
ln -s dotfiles/.tmux.conf .tmux.conf
ln -s dotfiles/.zshrc .zshrc
popd

uname_out="$(uname)"

if [[ "${uname_out}" == "Linux" ]]; then
    # TODO Add version check
    sudo add-apt-repository ppa:jonathonf/vim
    
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
    sudo apt-add-repository https://cli.github.com/packages
    sudo apt update
    sudo apt install vim
    # github cli tools
    sudo apt install gh

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    source ~/.zshrc
    nvm install 16
    nvm use 16

else
    brew install bash
    brew install vim
    brew install gh
    brew install node
    brew install rsync
fi

if [[ ! -e ~/.fzf.bash ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
else
  echo "FZF is already installed."
fi
