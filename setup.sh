#!/bin/bash
set -euo pipefail

if ! zsh --version &>/dev/null; then
  apt get install zsh
  sudo chsh $(which zsh)
fi

pushd ~ &>/dev/null
rm -f .vimrc .tmux.conf .zshrc .gitconfig
ln -s dotfiles/.vimrc .vimrc
ln -s dotfiles/.tmux.conf .tmux.conf
ln -s dotfiles/.zshrc .zshrc
ln -s dotfiles/.gitconfig .gitconfig

mkdir -p .vim/
pushd .vim/ &>/dev/null
rm -f coc-settings.json
ln -s ../dotfiles/coc-settings.json coc-settings.json
popd &>/dev/null

popd &>/dev/null

uname_out="$(uname)"

if [[ "${uname_out}" == "Linux" ]]; then
    vim_version=$(vim --version | sed -n 1p | cut -d ' ' -f '5')
    min_vim_version="9.0"
    printf -v versions '%s\n%s' "$vim_version" "$min_vim_version"
    if [[ ${vim_version} != ${min_vim_version} &&
          $versions = "$(sort -V <<< "$versions")" ]]; then
      sudo add-apt-repository ppa:jonathonf/vim
      sudo apt update
      sudo apt install vim
    fi
    
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
    # Some of these may come installed, but homebrew will update them.
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
fi
