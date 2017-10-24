#!/bin/bash

set -e

if [ ! -d install_scripts ];then
    ROOT=$(pwd)/..
else
    ROOT=$(pwd)
fi

. $ROOT/envset.sh

if [ -z $XDG_CURRENT_DESKTOP ];then
    echo "Don't have GUI"
    exit 1
fi

WORKDIR=$ROOT/tmp
mkdir -p $WORKDIR

#install prerequisite
${SUDO} add-apt-repository -y ppa:moka/daily
${SUDO} apt-get update && sudo apt-get upgrade -y
${SUDO} apt-get install -y libgtk-3-dev libvte-2.91-dev gnome-themes-standard gtk2-engines-murrine moka-icon-theme gnome-tweak-tool

#install terminator
${SUDO} apt-get install -y terminator

# install nanum gothic coding font
FILENAME=nanum.zip
curl -L https://github.com/naver/nanumfont/releases/download/VER2.5/NanumGothicCoding-2.5.zip -o $FILENAME && unzip -q $FILENAME NanumGothic* -d $HOME/.fonts && rm $FILENAME
${SUDO} fc-cache

#install Arc-theme and Moka icon theme
cd $WORKDIR
ARCFILE=arc.zip
ARCFOLDER=arc-theme-master
curl -L https://github.com/horst3180/arc-theme/archive/master.zip -o $ARCFILE && unzip -q $ARCFILE
cd $ARCFOLDER
./autogen.sh --prefix=$HOME/.local
make install

cd $WORKDIR
ARCICONFILE=arc-icon.zip
ARCICONFOLDER=arc-icon-theme
git clone https://github.com/horst3180/arc-icon-theme/archive/master.zip -o $ARCICONFILE && unzip -q $ARCICONFILE
cd $ARCICONFOLDER
./autogen.sh --prefix=$HOME/.local
make install

cd $PWD
rm -rf $WORKDIR
