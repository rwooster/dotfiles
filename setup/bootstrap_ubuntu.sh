#!/bin/bash
set -euo pipefail

if [[ "$(uname)" != "Linux" ]]; then
    echo "Are you sure you're running on Linux?"
    exit
fi

cd "${HOME}"

# Create folders
if [ ! -d "${HOME}/repos" ]; then
    mkdir -p "${HOME}/repos"
fi

# Checkout and install dotfiles
if [ ! -d "$HOME/repos/dotfiles" ]; then
    git clone -b dir_layout https://github.com/rwooster/dotfiles.git "$HOME/repos/dotfiles"
fi

${HOME}/repos/dotfiles/scripts/setup_ubuntu.sh
