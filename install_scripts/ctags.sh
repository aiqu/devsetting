#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="ctags"
TMP_DIR=$ROOT/tmp
TAG='5.8'
VER=$TAG
REPO_URL="http://prdownloads.sourceforge.net/ctags/ctags-$TAG.tar.gz"
FOLDER="$PKG_NAME*"
VERFILE=""
INSTALLED_VERSION=$(ctags --version | head -n1 | cut -d' ' -f3 | sed 's/,//')

if [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -LO $REPO_URL/archive/$TAG.zip
  unzip -q $TAG.zip && rm -rf $TAG.zip && cd $FOLDER
  curl -L $REPO_URL | tar xz && cd $FOLDER
  ./configure --prefix=$HOME/.local && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $VER is already installed"
fi

cd $ROOT
