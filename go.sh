#!/bin/bash

cp -v ./sources.list.d/* /etc/apt/sources.list.d

./apt.sh

# Setup vim
cp .vimrc ~/.vimrc
cp .tmux.conf ~/.tmux.conf
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim "+VundleInstall"

echo -e "\
TODO: \n
  * merge .bashrc by hand
"
