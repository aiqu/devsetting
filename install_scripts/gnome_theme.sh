#!/bin/bash

PWD=$(pwd)
REPOPATH=$HOME/.lib
mkdir -p $REPOPATH

#install prerequisite
sudo add-apt-repository ppa:moka/daily
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install libgtk-3-dev libvte-2.91-dev gnome-themes-standard gtk2-engines-murrine moka-icon-theme gnome-tweak-tool

#install tilda
cd $REPOPATH
git clone https://github.com/lanoxx/tilda.git
cd tilda && mkdir build && cd build
../autogen.sh --prefix=/usr
make --silent -j$(cat /proc/cpuinfo | grep processors | wc -l)
sudo make install
cd $PWD/../configurations
mkdir -p ${HOME}/.config/tilda
ln -s $(readlink -f config*) ${HOME}/.config/tilda

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
