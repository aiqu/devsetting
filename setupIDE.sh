#!/bin/bash

WD=$(pwd)

sudo apt update
sudo apt install cscope ctags unzip

mkdir -p ~/bin
rm -f ~/bin/mktags
ln -s ${WD}/mktags ~/bin/
rm -f ~/.vimrc
ln -s ${WD}/.vimrc ~/.vimrc

if [[ ! -d ~/.vim/bundle/Vundle.vim ]]
then
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

vim +PluginInstall +PluginUpdate +qall
unzip taglist_46.zip -d ~/.vim/
