#!/bin/bash
#
#    Protobuf installer
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

FILENAME=`basename $0`
FILENAME=${FILENAME%%.*}
DONENAME="DONE$FILENAME"
if [ ! -z ${!DONENAME+x} ];then
  return 0
fi
let DONE$FILENAME=1

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
source $ROOT/envset.sh

. $ROOT/install_scripts/autoconf.sh
. $ROOT/install_scripts/automake.sh
. $ROOT/install_scripts/make.sh
. $ROOT/install_scripts/unzip.sh
. $ROOT/install_scripts/libtool.sh

WORKDIR=$HOME/.lib
PKG_NAME="protobuf"
REPO_URL=https://github.com/google/protobuf
#TAG=$(git ls-remote --tags $REPO_URL | awk -F/ '{print $3}' | grep -v '{}' | sort -V | tail -n1)
TAG='v3.4.0'
VER=$(echo $TAG | sed 's/v//' -)
INSTALLED_VER=$(protoc --version 2>/dev/null | awk '{print $2}')
if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VER ] || [ ! $VER == $INSTALLED_VER ]; then
  iecho "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"

  cd $WORKDIR
  curl -LO ${REPO_URL}/archive/${TAG}.zip
  unzip -q ${TAG}.zip && rm -rf ${TAG}.zip protobuf
  mv protobuf-$VER protobuf && cd protobuf
  ./autogen.sh
  ./configure --prefix=${LOCAL_DIR}
  make -s -j$(nproc)
  make -s check -j$(nproc)
  make -s install 1>/dev/null
else
  gecho "$PKG_NAME $VER is already installed"
fi
