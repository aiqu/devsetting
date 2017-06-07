#!/bin/bash

sudo apt update
sudo apt install cscope ctags

mkdir -p ~/bin
ln -s mktags ~/bin/
ln -s .vimrc ~/.vimrc

if [[ ! -d ~/.vim/bundle/Vundle ]]
then
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

vim +PluginInstall +PluginUpdate +qall
