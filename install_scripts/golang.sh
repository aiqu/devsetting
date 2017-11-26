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

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="go"
INSTALL_DIR=$HOME/.local/go
NEW_INSTALL_DIR=$HOME/.local/go-new
BOOTSTRAP_TOOLCHAIN='https://storage.googleapis.com/golang/go1.4-bootstrap-20170531.tar.gz'
BOOTSTRAP_DIR="$INSTALL_DIR/go"
REPO_URL="https://go.googlesource.com/go"
TAG=$(git ls-remote -t $REPO_URL | grep -v -e '{}\|rc\|beta' | grep go | cut -d/ -f3 | sort -V | tail -n1)
VER=$(echo $TAG | sed 's/go//')
FOLDER="$PKG_NAME*"
VERFILE=""
INSTALLED_VERSION=$(go version | cut -d' ' -f3)

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $TAG != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"

  if [ ! -d $INSTALL_DIR ];then
    mkdir -p $INSTALL_DIR && cd $INSTALL_DIR
    curl -L $BOOTSTRAP_TOOLCHAIN | tar xz && cd go/src
    ./make.bash
  fi

  mkdir -p $NEW_INSTALL_DIR && cd $NEW_INSTALL_DIR
  curl -L $REPO_URL/+archive/$TAG.tar.gz | tar xz && cd src
  GOROOT_BOOTSTRAP=$BOOTSTRAP_DIR GOROOT_FINAL=$INSTALL_DIR ./make.bash
  rm -rf $INSTALL_DIR && mv $NEW_INSTALL_DIR $INSTALL_DIR
  ln -s $INSTALL_DIR/bin/go $HOME/.local/bin/go
else
  echo "$PKG_NAME $VER is already installed"
fi

cd $ROOT
