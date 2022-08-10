#!/bin/bash
set -euo pipefail

pushd ~
rm -f .vimrc .tmux.conf .zshrc
ln -s dotfiles/.vimrc .vimrc
ln -s dotfiles/.tmux.conf .tmux.conf
ln -s dotfiles/.zshrc .zshrc
ln -s dotfiles/.gitconfig .gitconfig
popd

uname_out="$(uname)"

if [[ "${uname_out}" == "Linux" ]]; then
    # TODO Add version check
    sudo add-apt-repository ppa:jonathonf/vim
    sudo apt update
    sudo apt install vim
    
    if ! gh --version &>/dev/null; then
      sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
      sudo apt-add-repository https://cli.github.com/packages
      # github cli tools
      sudo apt install gh
    fi

    if ! node --version &>/dev/null; then
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
      source ~/.zshrc
      nvm install 16
      nvm use 16
    fi

    if ! rg --help &>/dev/null; then
      wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
      sudo dpkg -i ripgrep*.deb
      rm ripgrep*.deb
    fi

else
    # Upgrade the local bash version
    brew install bash
    brew install vim
    brew install gh
    brew install node
    brew install rsync
    brew install rg
fi

if [[ ! -e ~/.fzf.bash ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
else
  echo "FZF is already installed."
fi
