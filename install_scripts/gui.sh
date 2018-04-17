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
./autogen.sh --prefix=${LOCAL_DIR}
make -s install 1>/dev/null

cd $WORKDIR
ARCICONFILE=arc-icon.zip
ARCICONFOLDER=arc-icon-theme
git clone https://github.com/horst3180/arc-icon-theme/archive/master.zip -o $ARCICONFILE && unzip -q $ARCICONFILE
cd $ARCICONFOLDER
./autogen.sh --prefix=${LOCAL_DIR}
make -s install 1>/dev/null

cd $PWD
rm -rf $WORKDIR
