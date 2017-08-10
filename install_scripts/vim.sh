#!/bin/bash

set -e

VIM_DONE=

if [ ! $ROOT ];then
    if [ ! -d 'install_scripts' ];then
        ROOT=$(pwd)/..
    else
        ROOT=$(pwd)
    fi
fi

if [ ! $CONFIGURATIONS_DONE ];then
    source $ROOT/install_scripts/configurations.sh
fi

echo "vim installation.. pwd: $PWD, root: $ROOT, core: $CORE"

REPO=$ROOT/repo

cd $ROOT
git submodule init
git submodule update
cd $REPO/vim
if [ ! -z ${REINSTALL_VIM+x} ];then
    make uninstall
    make clean
fi
make -j$CORE && make install

mkdir -p $HOME/.vim
cd $HOME/.vim

if [[ ! -d $HOME/.vim/bundle/Vundle.vim ]]
then
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

vim +PluginInstall +PluginUpdate +qall
unzip -u $ROOT/taglist_46.zip -d ~/.vim/

cd $PWD

VIM_DONE=1
