#!/bin/bash

PWD=$(pwd)

if [ -d repo ];then
    ROOT=$(pwd)
else
    ROOT=$(readlink -f ..)
fi

REPO=$ROOT/repo

cd $REPO/vim
make -j$(cat /proc/cpuinfo | grep processor | wc -l) && sudo make install

mkdir -p $HOME/.vim
cd $HOME/.vim

if [[ ! -d $HOME/.vim/bundle/Vundle.vim ]]
then
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

vim +PluginInstall +PluginUpdate +qall
unzip $ROOT/taglist_46.zip -d ~/.vim/

cd $PWD
