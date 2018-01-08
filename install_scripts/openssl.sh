#!/bin/bash
#
#    OpenSSL installer
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

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="openssl"
TMP_DIR=$ROOT/tmp
SRC_DIR=$HOME/.lib/openssl
REPO_URL="https://github.com/openssl/openssl"
TAG=$(git ls-remote -t $REPO_URL | grep -v -e '{}\|pre\|FIPS' | grep OpenSSL | cut -d/ -f3 | sort -V | tail -n1)
VER=$(echo $TAG | sed 's/OpenSSL.//' | sed 's/_/./g')
FOLDER="$PKG_NAME*"
VERFILE=""
INSTALLED_VERSION=$(openssl version | cut -d' ' -f2)

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  iecho "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL/archive/$TAG.tar.gz | tar xz
  cd $FOLDER
  ./config --prefix=${LOCAL_DIR} threads
  make -s -j$(nproc)
  make -s install_sw 1>/dev/null
  make -s install_man_docs 1>/dev/null

  cd $ROOT && rm -rf $SRC_DIR && mv $TMP_DIR/$FOLDER $SRC_DIR && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

cd $ROOT
