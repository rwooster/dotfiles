#!/bin/bash
set -euo pipefail

if [[ "$(uname)" != "Linux" ]]; then
  echo "Are you sure you're running on Linux?"
  exit
fi

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

SCRIPT_DIR=$(dirname $(readlink -f "$0"))
DOTFILES_DIR="${SCRIPT_DIR}/../"

# Make sure all the XDG_* env variables are loaded
source ${DOTFILES_DIR}/.zshenv

# Setup symlink farm
stow --version || sudo apt-get install stow
stow --dir="${DOTFILES_DIR}" --target="${HOME}" -R .

###
### Setup package servers
###

# For gh CLI: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null 


# For Alacritty: https://idroot.us/install-alacritty-ubuntu-24-04/#Method_1_Installing_Alacritty_via_PPA
# I don't know who maintains this ppa so probably a little sketchy
sudo add-apt-repository ppa:aslatter/ppa

# For Python3.9 (which may or may not work).
sudo add-apt-repository universe

###
### Install apt packages
###

sudo apt update

while read -r p ; do sudo apt-get install -y $p ; done < <(cat << "EOF"
  zsh
  gh
  tmux
  stow
  alacritty
  fontconfig
  python3.9
EOF
)

###
### Install without apt
###

# For some tools, it's easier to not be tied to the version avaialble in Ubuntu apt pacakges.
# Especially when required to run older Ubuntu versions.

# For NeoVim: https://github.com/neovim/neovim-releases
# Use the "unsupported" releases to use newest version on older Ubuntu
if ! nvim --verion &>/dev/null; then
  wget https://github.com/neovim/neovim-releases/releases/download/v0.11.1/nvim-linux-x86_64.deb
  sudo apt install ./nvim-linux-x86_64.deb
fi

# For nvm: https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating
# node is required by some tools like neovim Mason
if ! node --version &>/dev/null; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/refs/heads/master/install.sh
  export NVM_DIR="${XDG_CONFIG_HOME}/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
  nvm install node # Use the latest version
  nvm use node
fi

# For fzf: https://github.com/junegunn/fzf?tab=readme-ov-file#using-git
if ! fzf --version &>/dev/null; then
  git clone --depth 1 https://github.com/junegunn/fzf.git 
  ./fzf/install --bin
  mv ./fzf/bin/fzf ${XDG_BIN_HOME}/fzf
  rm -rf fzf
fi

# For rg: https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation
# TODO: Don't hard code a release version 
if ! rg --help &>/dev/null; then
  wget https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
  sudo dpkg -i ripgrep*.deb
  rm ripgrep*.deb
fi

# For fd: https://github.com/sharkdp/fd?tab=readme-ov-file#installation
# TODO: Don't hard code a release version 
if ! fd --help &>/dev/null; then
  wget https://github.com/sharkdp/fd/releases/download/v10.2.0/fd_10.2.0_amd64.deb
  sudo dpkg -i fd*.deb
  rm fd*.deb
fi

# Install font to use: https://www.nerdfonts.com/font-downloads
if [[ ! -d ${XDG_DATA_HOME}/fonts ]]; then 
  mkdir -p "$XDG_DATA_HOME"/fonts
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraMono.zip
  unzip FiraMono.zip -d "$XDG_DATA_HOME"/fonts
  fc-cache -fv "$XDG_DATA_HOME"/fonts
  rm FiraMono.zip
fi

# Install various themes for alacritty
if [[ ! -d ${XDG_CONFIG_HOME}/alacritty/themes ]]; then
    mkdir -p ${XDG_CONFIG_HOME}/alacritty/themes
    git clone https://github.com/alacritty/alacritty-theme ${XDG_CONFIG_HOME}/alacritty/themes --depth=1
fi

is_zsh=$(echo $SHELL | grep zsh)
if [ -z "${is_zsh}" ]; then
  chsh -s $(which zsh) ${USER}
fi
