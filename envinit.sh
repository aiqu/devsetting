#!/bin/bash

PWD=$(pwd)
REPOPATH=$HOME'/.repo'
mkdir -p $REPOPATH

#install prerequisite
sudo add-apt-repository ppa:moka/daily
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install vim git dh-autoreconf autotools-dev debhelper dh-autoreconf libconfuse-dev libgtk-3-dev libvte-2.91-dev pkg-config autoconf automake gnome-themes-standard gtk2-engines-murrine moka-icon-theme gnome-tweak-tool

#install Vundle plugin
cp .vimrc $HOME
mkdir -p ~/.vim/bundle/
cd ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git
vim +PluginInstall +qall

#install tilda
cd $REPOPATH
git clone https://github.com/lanoxx/tilda.git
cd tilda && mkdir build && cd build
../autogen.sh --prefix=/usr
make --silent
sudo make install
cd $PWD
mkdir -p $HOME'/.config/tilda'
cp config* $HOME'/.config/tilda'

#install Arc-theme and Moka icon theme
cd $REPOPATH
git clone https://github.com/horst3180/arc-theme --depth 1
cd arc-theme
./autogen.sh --prefix=/usr
sudo make install
cd $REPOPATH
git clone https://github.com/horst3180/arc-icon-theme --depth 1
cd arc-icon-theme
./autogen.sh --prefix=/usr
sudo make install

cd $HOME
gnome-tweak-tool
