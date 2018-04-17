#!/usr/bin/env bash
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

FILENAME=`basename ${BASH_SOURCE[0]}`
FILENAME=${FILENAME%%.*}
DONENAME="DONE$FILENAME"
if [ ! -z ${!DONENAME+x} ];then
  return 0
fi
let DONE$FILENAME=1

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="bzip2"
TAG='1.0.6'
VER=$TAG
REPO_URL="http://www.bzip.org/$TAG/bzip2-$TAG.tar.gz"
FOLDER="$PKG_NAME*"
INSTALLED_VERSION=$(${LOCAL_DIR}/bin/bzip2 -h 2>&1 | head -n1 | cut -d' ' -f8 | sed 's/,//')

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL | tar xz
  cd $FOLDER
  make -s -j$(nproc)
  make -s install PREFIX=${LOCAL_DIR} 1>/dev/null
  make -s -f Makefile-libbz2_so clean
  make -s -f Makefile-libbz2_so -j$(nproc)
  cp -a libbz2.so* ${LOCAL_DIR}/lib
  SHAREDLIB=$(find . -name 'libbz2.so*' -type f)
  ln -s $SHAREDLIB ${LOCAL_DIR}/lib/libbz2.so

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

cd $ROOT
