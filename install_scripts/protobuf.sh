#!/usr/bin/env bash
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

FILENAME=`basename ${BASH_SOURCE[0]}`
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
TAG=$(git ls-remote --tags $REPO_URL | awk -F/ '{print $3}' | grep -v '{}\|rc' | sort -V | tail -n1 | sed 's/\(v[0-9,\.]\{5\}\).*/\1/')
if [ $LEVEL -le 1 ];then
  TAG=${CUSTOMTAG:-$TAG}
fi
VER=$(echo $TAG | sed 's/v//' -)
INSTALLED_VER=
if hash protoc 2>/dev/null;then
  INSTALLED_VER=$(protoc --version 2>/dev/null | awk '{print $2}')
fi
if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_VER ] || $(compare_version $INSTALLED_VER $VER); then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

  cd $WORKDIR
  curl -LO ${REPO_URL}/releases/download/${TAG}/protobuf-all-${VER}.zip
  unzip -q protobuf-all-${VER}.zip && rm -rf protobuf-all-${VER}.zip protobuf
  mv protobuf-$VER protobuf && cd protobuf
  ./autogen.sh
  ./configure --prefix=${LOCAL_DIR} --libdir=${LOCAL_DIR}/lib64
  make -s -j${NPROC}
  make -s check -j${NPROC}
  make -s install 1>/dev/null
else
  gecho "$PKG_NAME $VER is already installed"
fi

LEVEL=$(( ${LEVEL}-1 ))
