SCRIPT_DIR=$(dirname $(readlink -f "$0"))
DOTFILES_DIR="${SCRIPT_DIR}/../"

# Make sure all the XDG_* env variables are loaded
source ${DOTFILES_DIR}/config/zsh/.zshenv

# Make sure all the XDG_* directories exist
mkdir -p ${XDG_CONFIG_HOME}
mkdir -p ${XDG_CACHE_HOME}
mkdir -p ${LOCAL_HOME}
mkdir -p ${XDG_BIN_HOME}
mkdir -p ${XDG_DATA_HOME}
mkdir -p $XDG_DATA_HOME/fonts

# Make sure XDG Bin is on the path
export PATH="${XDG_BIN_HOME}:${PATH}"

# Setup symlink farm
for package in $(find ${DOTFILES_DIR}/config -mindepth 1 -maxdepth 1 -type d | xargs basename -a); do
    mkdir -p "${HOME}/.config/${package}/"
    stow -R --dir="${DOTFILES_DIR}/config/" --target="${HOME}/.config/${package}/" ${package}
done

# Special handling of the .zshenv, which must live at the root
ln -f -s "${HOME}/.config/zsh/.zshenv" "${HOME}/.zshenv"
