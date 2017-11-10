#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="texinfo"
TMP_DIR=$ROOT/tmp
TAG='6.5'
VER=$TAG
REPO_URL="https://ftp.gnu.org/gnu/texinfo/texinfo-$TAG.tar.xz"
FOLDER="$PKG_NAME*"
INSTALLED_VERSION=$(makeinfo --version 2>/dev/null | head -n1 | cut -d' ' -f4)

if [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL | tar xJ && cd $FOLDER
  mkdir -p build && cd build && \
  ./configure --prefix=$HOME/.local && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $VER is already installed"
fi

cd $ROOT
