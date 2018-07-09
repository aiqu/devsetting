#!/usr/bin/env bash
#
#    Unzip installer
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

if [ $OS == 'mac' ];then
  brew install unzip
else
  PKG_NAME="unzip"
  REPO_URL="https://downloads.sourceforge.net/infozip/unzip60.tar.gz"
  FOLDER="$PKG_NAME*"
  VER='6.00'
  INSTALLED_VERSION=
  if hash unzip 2>/dev/null;then
    INSTALLED_VERSION=$(unzip -v | head -n1 | cut -d' ' -f2)
  fi
  if [ ! -z $REINSATLL ] || [ -z $INSTALLED_VERSION ] || $(compare_version $INSTALLED_VERSION $VER); then
    iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

    mkdir -p $TMP_DIR && cd $TMP_DIR
    curl -L $REPO_URL | tar xz
    cd $FOLDER
    if [ $OS == 'mac' ]; then
      make -s -f macos/Makefile -j${NPROC} generic
    else
      make -s -f unix/Makefile -j${NPROC} generic
    fi
    make -s prefix=${LOCAL_DIR} MANDIR=${LOCAL_DIR}/share/man/man1 -f unix/Makefile install

    cd $ROOT && rm -rf $TMP_DIR
  else
    gecho "$PKG_NAME $VER is already installed"
  fi

  cd $ROOT
fi

LEVEL=$(( ${LEVEL}-1 ))
