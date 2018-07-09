#!/usr/bin/env bash
#
#    <libssh2> installer
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

_R=$REINSTALL
unset REINSTALL
. $ROOT/install_scripts/openssl.sh
REINSTALL=$_R
unset _R

PKG_NAME="libssh2"
REPO_URL="https://github.com/libssh2/libssh2"
TAG=$(git ls-remote -t $REPO_URL | grep -v '{}\|start' | cut -d/ -f3 | sort -V | tail -n1)
VER=$(echo $TAG | cut -d'-' -f2)
FOLDER="$PKG_NAME*"
VERFILE=""
INSTALLED_VERSION=
if $(pkg-config --exists $PKG_NAME);then
  INSTALLED_VERSION=$(pkg-config --modversion $PKG_NAME)
fi
if [ "$INSTALLED_VERSION" = "1.7.0_DEV" ];then
  # 1.8.0 produces 1.7.0_DEV version string
  INSTALLED_VERSION="1.8.0"
fi

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || $(compare_version $INSTALLED_VERSION $VER); then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -LO $REPO_URL/archive/$TAG.zip
  unzip -q $TAG.zip && rm -rf $TAG.zip && cd $FOLDER
  mkdir -p build && cd build
  cmake -DCMAKE_INSTALL_PREFIX=${LOCAL_DIR} -DBUILD_SHARED_LIBS=ON ..
  make -s -j${NPROC}
  make -s install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

cd $ROOT
