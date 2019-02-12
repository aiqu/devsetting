#!/usr/bin/env bash
#
#    <g2o> installer
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

if [ -z $SKIPDEPS ];then
  . $ROOT/install_scripts/suitesparse.sh
fi

PKG_NAME="g2o"
REPO_URL="https://github.com/RainerKuemmerle/g2o"
TAG="master"
CUSTOMTAGNAME="${PKG_NAME}TAG"
TAG=${!CUSTOMTAGNAME:-$TAG}
VER="$TAG"
FOLDER="$PKG_NAME*"
INSTALLED_VERSION=

if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_VERSION ] || $(compare_version $INSTALLED_VERSION $VER); then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl --retry 10 -L $REPO_URL/archive/$TAG.tar.gz | tar xz && cd $FOLDER
  mkdir -p build && cd build
  BUILDSTATIC="${PKG_NAME}STATIC"
  CMAKE_OPTIONS=" \
    -DCMAKE_INSTALL_PREFIX=${LOCAL_DIR} \
    -DCMAKE_BUILD_TYPE=Release \
    -DG2O_BUILD_APPS=OFF \
    -DG2O_BUILD_EXAMPLES=OFF \
    -DBUILD_WITH_MARCH_NATIVE=OFF \
    "
  if [ ! -z ${!BUILDSTATIC} ];then
    CMAKE_OPTIONS="${CMAKE_OPTIONS} -DBUILD_SHARED_LIBS=OFF -DBUILD_LGPL_SHARED_LIBS=OFF"
  fi
  cmake $CMAKE_OPTIONS ..
  make -s -j${NPROC}
  make -s install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

LEVEL=$(( ${LEVEL}-1 ))
cd $ROOT
