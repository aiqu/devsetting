#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="bzip2"
TMP_DIR=$ROOT/tmp
TAG='1.0.6'
VER=$TAG
REPO_URL="http://www.bzip.org/$TAG/bzip2-$TAG.tar.gz"
FOLDER="$PKG_NAME*"
INSTALLED_VERSION=$(bzip2 -h 2>&1 | head -n1 | cut -d' ' -f8 | sed 's/,//')

if [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL | tar xz && cd $FOLDER
  make -j$(nproc) && make install PREFIX=$HOME/.local

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $VER is already installed"
fi

cd $ROOT
