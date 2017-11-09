#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="autoconf"
TMP_DIR=$ROOT/tmp
TAG='2.69'
REPO_URL="http://ftp.gnu.org/gnu/autoconf/autoconf-$TAG.tar.gz"
VER=$TAG
FOLDER="$PKG_NAME*"
INSTALLED_VERSION=$(autoconf --version | head -n1 | cut -d' ' -f4)

if [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $TAG installation.. pwd: $PWD, root: $ROOT, core: $CORE"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL | tar xz && cd $FOLDER
  ./configure --prefix=$HOME/.local && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $VER is already installed"
fi

cd $ROOT
