#!/bin/bash
set -euo pipefail

if [[ "$(uname)" == "Linux" ]]; then
  echo "Are you sure you're running on MacOS?"
  exit
fi

# Install homebrew
if ! which brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Make sure GNU stow is installed.
brew install stow -q

# Run common setup steps
source $(dirname $(readlink -f "$0"))/common.sh

# Install required packages
brew bundle check --global || brew bundle install --global

# Install various themes for alacritty
if [ ! -d ${HOME}/.config/alacritty/themes ]; then
    mkdir -p ${HOME}/.config/alacritty/themes
    git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes --depth=1
fi
