#!/bin/bash
#
#    newt installer
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
. $ROOT/envset.sh

TMP_DIR=$ROOT/tmp

#slang library installation
PKG_NAME="slang"
VER="2.1.4"
VERFILE="${LOCAL_DIR}/include/slang.h"
INSTALLED_VER=$(cat $VERFILE | grep -e 'define SLANG_VERSION_STRING "' | cut -d'"' -f2)
if [ ! -r $VERFILE ] || [ $INSTALLED_VER != $VER ];then
  iecho "$PKG_NAME $VER installation.."
  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L ftp://space.mit.edu/pub/davis/slang/v2.1/slang-2.1.4.tar.gz | tar xz
  cd slang-2.1.4
  ./configure --prefix=${LOCAL_DIR}
  make -s -j$(nproc)
  make -s install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

PKG_NAME="popt"
VER="1.16"
VERFILE="${LOCAL_DIR}/include/popt.h"
if [ ! -f $VERFILE ];then
  iecho "$PKG_NAME $VER installation.."
  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L http://rpm5.org/files/popt/popt-1.16.tar.gz | tar xz
  cd popt-1.16
  ./configure --prefix=${LOCAL_DIR}
  make -s -j$(nproc)
  make -s install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

PKG_NAME="newt"
REPO_URL=https://pagure.io/newt.git
TAG=$(git ls-remote -t $REPO_URL | cut -d'/' -f3 | grep -v v | sort -V | tail -n1)
VER=$(echo $TAG | sed 's/[r|.zip]//g' | sed 's/-/./g')
FOLDER="newt-$VER"
INSTALLED_VER=$(find ${LOCAL_DIR}/lib -mindepth 1 -maxdepth 1 -type f | grep newt.so | sed 's/.*libnewt.so.//')
if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VER ] || [ $VER != $INSTALLED_VER ];then
  iecho "$PKG_NAME $VER installation.."

  mkdir -p $TMP_DIR && cd $TMP_DIR
  DOWN_URL=https://releases.pagure.org/newt/newt-$VER.tar.gz
  curl -L $DOWN_URL | tar xz
  cd $FOLDER
  ./configure --prefix=${LOCAL_DIR}
  make -s -j$(nproc)
  make -s install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

cd $ROOT
