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

# Install base prerequisites
brew install git -q
brew install stow -q

SCRIPT_DIR=$(dirname $(readlink -f "$0"))
DOTFILES_DIR="${SCRIPT_DIR}/../"

stow --dir="${DOTFILES_DIR}" --target="${HOME}" -R .

brew bundle check || brew bundle install

# We use Alacritty's default Linux config directory as our storage location here.
if [ ! -d ${HOME}/.config/alacritty/themes ]; then
    mkdir -p ${HOME}/.config/alacritty/themes
    git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes --depth=1
fi
