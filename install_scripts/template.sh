#!/usr/bin/env bash
#
#    <packagename> installer
#
#    Copyright (C) 2018 Gwangmin Lee
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

PKG_NAME="packagename"
REPO_URL=""
TAG=$(git ls-remote -t $REPO_URL | grep -v {} | cut -d/ -f3 | sort -V | tail -n1)
VER=$TAG
FOLDER="$PKG_NAME*"
VERFILE=""
INSTALLED_VERSION=$()
if $(pkg-config --exists $PKG_NAME);then
  INSTALLED_VERSION=$(pkg-config --modversion $PKG_NAME)
fi

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $(compare_version $INSTALLED_VERSION $VER) ]; then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -LO $REPO_URL/archive/$TAG.zip
  unzip -q $TAG.zip && rm -rf $TAG.zip && cd $FOLDER
  curl -L $REPO_URL | tar xz
  cd $FOLDER
  mkdir -p build && cd build
  cmake -DCMAKE_INSTALL_PREFIX=${LOCAL_DIR} ..
  ./configure --prefix=${LOCAL_DIR}
  make -s -j${NPROC}
  make -s install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

cd $ROOT
