#!/bin/bash
set -euo pipefail

cd "${HOME}"

# Create folders
if [ ! -d "${HOME}/repos" ]; then
    mkdir -p "${HOME}/repos"
fi

# Checkout and install dotfiles
if [ ! -d "$HOME/repos/dotfiles" ]; then
    git clone -b dir_layout https://github.com/rwooster/dotfiles.git "$HOME/repos/dotfiles"
fi

if [[ "$(uname)" != "Linux" ]]; then
    ${HOME}/repos/dotfiles/setup/setup_macos.sh
else
    ${HOME}/repos/dotfiles/setup/setup_ubuntu.sh
fi
