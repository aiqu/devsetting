#!/bin/bash
#
#    m4 installer
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

PKG_NAME="m4"
REPO_URL="http://ftp.gnu.org/gnu/m4/m4-latest.tar.xz"
FOLDER="$PKG_NAME*"

mkdir -p $TMP_DIR && cd $TMP_DIR
curl -L $REPO_URL | tar xJ
cd $FOLDER

VER=$(pwd | cut -d'-' -f2)
set +e
INSTALLED_VERSION=$(m4 --version 2>/dev/null | head -n1 | cut -d' ' -f4)
set -e

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"
  ./configure --prefix=${LOCAL_DIR}
  make -s -j$(nproc)
  make -s install 1>/dev/null
  
else
  gecho "$PKG_NAME $VER is already installed"
fi

cd $ROOT && rm -rf $TMP_DIR
