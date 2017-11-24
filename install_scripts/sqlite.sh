#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="sqlite"
TMP_DIR=$ROOT/tmp
TAG='3210000'
VER='3.21.0'
REPO_URL="http://www.sqlite.org/2017/sqlite-autoconf-$TAG.tar.gz"
FOLDER="$PKG_NAME*"
VERFILE=""
INSTALLED_VERSION=$(sqlite3 --version | cut -d' ' -f1)

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL | tar xz && cd $FOLDER
  ./configure --prefix=$HOME/.local && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $VER is already installed"
fi

cd $ROOT
