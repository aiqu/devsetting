#!/bin/bash

PWD=$(pwd)
REPO=repo

cd $REPO/vim
make -j$(cat /proc/cpuinfo | grep processor | wc -l) && sudo make install
cd $PWD

mkdir -p $HOME/.vim

if [[ ! -d $HOME/.vim/bundle/Vundle.vim ]]
then
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

vim +PluginInstall +PluginUpdate +qall
unzip ../taglist_46.zip -d ~/.vim/
