#!/bin/bash
#
#    Bzip2 installer
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
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="bzip2"
TMP_DIR=$ROOT/tmp
TAG='1.0.6'
VER=$TAG
REPO_URL="http://www.bzip.org/$TAG/bzip2-$TAG.tar.gz"
FOLDER="$PKG_NAME*"
INSTALLED_VERSION=$($HOME/.local/bin/bzip2 -h 2>&1 | head -n1 | cut -d' ' -f8 | sed 's/,//')

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  iecho "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL | tar xz
  cd $FOLDER
  make -s -j$(nproc)
  make -s install PREFIX=$HOME/.local 1>/dev/null
  make -s -f Makefile-libbz2_so clean
  make -s -f Makefile-libbz2_so -j$(nproc)
  cp -a libbz2.so* $HOME/.local/lib
  SHAREDLIB=$(find . -name 'libbz2.so*' -type f)
  ln -s $SHAREDLIB $HOME/.local/lib/libbz2.so

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

cd $ROOT
