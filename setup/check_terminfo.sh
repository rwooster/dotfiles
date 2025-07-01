#!/bin/zsh

# Check that alacritty terminfo is set properly
# https://github.com/alacritty/alacritty/blob/master/INSTALL.md#post-build
# https://michenriksen.com/posts/italic-text-in-alacritty-tmux-neovim/

echo -e '\e[1mBold\e[22m'
echo -e '\e[2mDimmed\e[22m'
echo -e '\e[3mItalic\e[23m'
echo -e '\e[4mUnderlined\e[24m'
echo -e '\e[4:3mCurly Underlined\e[4:0m'
echo -e '\e[4:3m\e[58;2;240;143;104mColored Curly Underlined\e[59m\e[4:0m'
