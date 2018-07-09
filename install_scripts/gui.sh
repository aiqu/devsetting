#!/usr/bin/env bash
#
#    GUI environment installer
#
#    Copyright (C) 2017 Gwangmin Lee
#    
#    Author: Gwangmin Lee <gwangmin0123@gmail.com>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

set -e

FILENAME=`basename ${BASH_SOURCE[0]}`
FILENAME=${FILENAME%%.*}
DONENAME="DONE$FILENAME"
if [ ! -z ${!DONENAME+x} ];then
  return 0
fi
let DONE$FILENAME=1

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

. $ROOT/envset.sh

if [ -z $XDG_CURRENT_DESKTOP ];then
    echo "Don't have GUI"
    exit 1
fi

#install prerequisite
${SUDO} add-apt-repository -y ppa:moka/daily
${SUDO} apt-get update && sudo apt-get upgrade -y
${SUDO} apt-get install -y libgtk-3-dev libvte-2.91-dev gnome-themes-standard gtk2-engines-murrine moka-icon-theme gnome-tweak-tool

#install terminator
${SUDO} apt-get install -y terminator

# install coding font
FILENAME=font.zip
curl -L https://github.com/naver/nanumfont/releases/download/VER2.5/NanumGothicCoding-2.5.zip -o $FILENAME && unzip -fq $FILENAME NanumGothic* -d $HOME/.fonts && rm $FILENAME
curl -L https://github.com/naver/d2codingfont/releases/download/VER1.3.1/D2Coding-Ver1.3.1-20180115.zip -o $FILENAME && unzip -fq $FILENAME D2Coding* -d $HOME/.fonts && rm $FILENAME
${SUDO} fc-cache

#install Arc-theme and Moka icon theme
curl -L https://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/all/arc-theme_1488477732.766ae1a-0_all.deb -o arc-theme.deb
${SUDO} dpkg -i arc-theme.deb
rm arc-theme.deb

mkdir -p $TMP_DIR && cd $TMP_DIR
git clone https://github.com/horst3180/arc-icon-theme --depth 1 && cd arc-icon-theme
./autogen.sh
${SUDO} make -j${NPROC} install

LEVEL=$(( ${LEVEL}-1 ))
cd $ROOT
rm -rf $TMP_DIR
