#!/usr/bin/env bash
#
#    ncurses installer
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

PKG_NAME="ncurses"
REPO_URL=http://invisible-island.net/datafiles/release/ncurses.tar.gz
FOLDER='ncurses*'
VERFILE="${LOCAL_DIR}/include/ncursesw/curses.h"
INSTALLED_VERSION=
if [ -r $VERFILE ];then
  INSTALLED_VERSION=$(cat $VERFILE | grep -e 'define NCURSES_VERSION ' | cut -d'"' -f2)
fi

if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_VERSION ]; then
  iecho "$PKG_NAME installation.. install location: $LOCAL_DIR"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL | tar xz
  cd $FOLDER
  ./configure --prefix=${LOCAL_DIR} --enable-widec --without-develop --without-cxx-binding --with-shared CPPFLAGS='-P'
  make -s -j${NPROC}
  make -s install 1>/dev/null
  ln -sf ${LOCAL_DIR}/include/ncursesw/*.h ${LOCAL_DIR}/include/
  ln -sf libncursesw.so ${LOCAL_DIR}/lib/libcurses.so

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $INSTALLED_VERSION is already installed"
fi

LEVEL=$(( ${LEVEL}-1 ))
cd $ROOT
