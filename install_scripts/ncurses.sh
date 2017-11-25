#!/bin/bash
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

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
. $ROOT/envset.sh

TMP_DIR=$ROOT/tmp
REPO_URL=http://invisible-island.net/datafiles/release/ncurses.tar.gz
FOLDER='ncurses'
VERFILE="$HOME/.local/include/ncursesw/curses.h"
if [ -z $REINSTALL ] && [ -r $VERFILE ];then
  INSTALLED_VERSION=$(cat $VERFILE | grep -e 'define NCURSES_VERSION ' | cut -d'"' -f2)
  echo "ncurses $INSTALLED_VERSION is already installed"
else
  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL | tar xz && cd ncurses*
  ./configure --prefix=$HOME/.local --enable-widec --without-develop --without-cxx-binding --with-shared CPPFLAGS='-P' && \
    make -s -j$(nproc) && make -s install 1>/dev/null
  ln -sf $HOME/.local/include/ncursesw/*.h $HOME/.local/include/
  ln -sf libncursesw.so $HOME/.local/lib/libcurses.so

  cd $ROOT && rm -rf $TMP_DIR
fi

cd $ROOT
