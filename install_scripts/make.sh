#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="make"
TMP_DIR=$ROOT/tmp
REPO_URL="http://ftp.gnu.org/gnu/make/make-3.82.tar.bz2"
TAG=$(echo $REPO_URL | cut -d'-' -f2 | sed 's/.tar.bz2//');
VER=$TAG
FOLDER="$PKG_NAME*"
VERFILE=""
set +e
INSTALLED_VERSION=$(make -v 2>/dev/null | head -n1 | cut -d' ' -f3)
set -e

if [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL | tar xj && cd $FOLDER
  ./configure --prefix=$HOME/.local
  if [ ! -f $HOME/.local/bin/make ];then
    sh build.sh && ./make install
  else
    make -j$(nproc) && make install
  fi

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $VER is already installed"
fi

cd $ROOT
