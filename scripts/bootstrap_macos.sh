#!/bin/bash
set -euo pipefail

if [[ "$(uname)" == "Linux" ]]; then
    echo "Are you sure you're running on MacOS?"
    exit
fi

cd "${HOME}"

# Create folders
if [ ! -d "${HOME}/repos" ]; then
    mkdir -p "${HOME}/repos"
fi

# Checkout and install dotfiles
if [ ! -d "$HOME/repos/dotfiles" ]; then
    git clone git@github.com:rwooster/dotfiles.git "$HOME/repos/dotfiles"
fi

./repos/dotfiles/scripts/setup_macos.sh
