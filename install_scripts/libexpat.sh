#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="libexpat"
TMP_DIR=$ROOT/tmp
REPO_URL="https://github.com/libexpat/libexpat"
TAG=$(git ls-remote -t $REPO_URL | grep -v {} | grep R | cut -d/ -f3 | sort -V | tail -n1)
VER=$(echo $TAG | sed 's/R_//' | sed 's/_/./g')
FOLDER="$PKG_NAME*"
VERFILE=""
if pkg-config expat --exists ;then
  INSTALLED_VERSION=$(pkg-config expat --modversion)
fi

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -LO $REPO_URL/archive/$TAG.zip
  unzip -q $TAG.zip && rm -rf $TAG.zip && cd $FOLDER
  cd expat && ./buildconf.sh
  ./configure --prefix=$HOME/.local --without-xmlwf && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $VER is already installed"
fi

cd $ROOT
