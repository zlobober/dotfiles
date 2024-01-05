#!/bin/bash
cp vimrc ~/.vimrc
cp tmux.conf ~/.tmux.conf
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim "+VundleInstall"
