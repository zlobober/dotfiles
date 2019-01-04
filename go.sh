#!/bin/bash

./apt.sh

# Setup vim
cp .vimrc ~/.vimrc
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim "+VundleInstall"

echo -e "\
TODO: \n
  * merge .bashrc by hand
"
