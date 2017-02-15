#!/bin/bash

mkdir -p ~/.envinit
cd ~/.envinit
sudo add-apt-repository ppa:moka/daily
sudo apt-get update

sudo apt-get install autoconf automake libgtk-3-dev gnome-themes-standard gtk2-engines-murrine moka-icon-theme gnome-tweak-tool
git clone https://github.com/horst3180/arc-theme --depth 1
cd arc-theme
./autogen.sh --prefix=/usr
sudo make install

cd ~/.envinit
git clone https://github.com/horst3180/arc-icon-theme --depth 1
cd arc-icon-theme
./autogen.sh --prefix=/usr
sudo make install

cd ~
gnome-tweak-tool
