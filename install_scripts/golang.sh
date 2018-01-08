#!/bin/bash
#
#    Golang installer
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

PKG_NAME="go"
INSTALL_DIR=${LOCAL_DIR}/go
NEW_INSTALL_DIR=${LOCAL_DIR}/go-new
BOOTSTRAP_TOOLCHAIN='https://storage.googleapis.com/golang/go1.4-bootstrap-20170531.tar.gz'
BOOTSTRAP_DIR="${LOCAL_DIR}/go-bootstrap"
TMP_DIR="/tmp/go"
REPO_URL="https://go.googlesource.com/go"
TAG=$(git ls-remote -t $REPO_URL | grep -v -e '{}\|rc\|beta' | grep go | cut -d/ -f3 | sort -V | tail -n1)
VER=$(echo $TAG | sed 's/go//')
FOLDER="$PKG_NAME*"
VERFILE=""
INSTALLED_VERSION=$(go version | cut -d' ' -f3)

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $TAG != $INSTALLED_VERSION ]; then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

  if [ ! -x $BOOTSTRAP_DIR/bin/go ];then
    iecho "Cannot find go 1.4 for bootstrap. Install it first"
    mkdir -p $TMP_DIR && cd $TMP_DIR
    curl -L $BOOTSTRAP_TOOLCHAIN | tar xz && cd go/src
    GOROOT_FINAL=$BOOTSTRAP_DIR ./make.bash
    rm -rf $BOOTSTRAP_DIR && mv $TMP_DIR/go $BOOTSTRAP_DIR
  fi

  mkdir -p $NEW_INSTALL_DIR && cd $NEW_INSTALL_DIR
  curl -L $REPO_URL/+archive/$TAG.tar.gz | tar xz
  cd src
  GOROOT_BOOTSTRAP=$BOOTSTRAP_DIR GOROOT_FINAL=$INSTALL_DIR ./make.bash
  rm -rf $INSTALL_DIR && mv $NEW_INSTALL_DIR $INSTALL_DIR
  ln -s $INSTALL_DIR/bin/* ${LOCAL_DIR}/bin/
else
  gecho "$PKG_NAME $VER is already installed"
fi

cd $ROOT
