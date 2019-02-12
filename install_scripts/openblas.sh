#!/usr/bin/env bash
#
#    openblas installer
#
#    Copyright (C) 2019 Gwangmin Lee
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

PKG_NAME="openblas"
REPO_URL="https://github.com/xianyi/OpenBLAS"
TAG=$(git ls-remote -t $REPO_URL | grep -v {} | cut -d/ -f3 | sort -V | tail -n1)
CUSTOMTAGNAME="$(echo ${PKG_NAME} | sed 's/-//')TAG"
TAG=${!CUSTOMTAGNAME:-$TAG}
VER=$(echo $TAG | sed 's/v//')
FOLDER="OpenBLAS*"
VERFILE=$(find /usr -type f -name 'openblas_config.h')
INSTALLED_VERSION=
if [ -r $VERFILE ];then
  INSTALLED_VERSION=$(cat $VERFILE | grep OPENBLAS_VERSION | awk -F' ' '{ print $5 }')
fi

if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_VERSION ] || $(compare_version $INSTALLED_VERSION $VER); then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl --retry 10 -L $REPO_URL/archive/$TAG.tar.gz | tar xz && cd $FOLDER
  mkdir -p build && cd build
  BUILDSTATIC="$(echo ${PKG_NAME} | sed 's/-//')STATIC"
  CMAKE_OPTIONS="-DCMAKE_INSTALL_PREFIX=${LOCAL_DIR}"
  if [ ! -z ${!BUILDSTATIC} ];then
    CMAKE_OPTIONS="$CMAKE_OPTIONS -DBUILD_SHARED_LIBS=OFF"
  fi
  cmake $CMAKE_OPTIONS ..
  make -s -j${NPROC}
  make -s install PREFIX=${LOCAL_DIR} 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

LEVEL=$(( ${LEVEL}-1 ))
cd $ROOT
