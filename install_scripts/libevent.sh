#!/usr/bin/env bash
#
#    libevent installer
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

. $ROOT/install_scripts/cmake.sh

PKG_NAME="libevent"
REPO_URL=https://github.com/libevent/libevent
TAG=$(git ls-remote --tags $REPO_URL | grep release | awk -F/ '{print $3}' | grep -v '{}' | sort -V | tail -n1)
FOLDER="libevent-$TAG"
VER=$(echo $TAG | awk -F'-' '{print $2}')
VERFILE="${LOCAL_DIR}/include/event2/event-config.h"
INSTALLED_VERSION=
if [ -r $VERFILE ];then
  INSTALLED_VERSION=$(grep PACKAGE_VERSION $VERFILE | cut -d'"' -f2)
fi

if ([ $LEVEL = 0 ] && [ ! -z $REINSTALL ]) || [ -z $INSTALLED_VERSION ] || $(compare_version $INSTALLED_VERSION $VER); then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

  mkdir -p $TMP_DIR && cd $TMP_DIR

  curl -LO ${REPO_URL}/archive/${TAG}.zip
  unzip -q ${TAG}.zip
  cd $FOLDER
  # Wierd, but install twice for pkg-config and cmake
  ./autogen.sh
  ./configure --prefix=${LOCAL_DIR} --disable-debug-mode --disable-samples
  make -s -j${NPROC} && make -s install 1>/dev/null
  mkdir -p build && cd build
  cmake -DCMAKE_INSTALL_PREFIX=${LOCAL_DIR} \
    -DEVENT__DISABLE_DEBUG_MODE=ON \
    -DEVENT__DISABLE_TESTS=ON \
    -DEVENT__DISABLE_SAMPLES=ON \
    ..
  make -s -j${NPROC}
  make -s install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

LEVEL=$(( ${LEVEL}-1 ))
cd $ROOT
