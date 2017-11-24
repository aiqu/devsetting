#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="m4"
TMP_DIR=$ROOT/tmp
REPO_URL="http://ftp.gnu.org/gnu/m4/m4-latest.tar.xz"
FOLDER="$PKG_NAME*"

mkdir -p $TMP_DIR && cd $TMP_DIR
curl -L $REPO_URL | tar xJ && cd $FOLDER

VER=$(pwd | cut -d'-' -f2)
set +e
INSTALLED_VERSION=$(m4 --version 2>/dev/null | head -n1 | cut -d' ' -f4)
set -e
if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"
  ./configure --prefix=$HOME/.local && \
  make -j$(nproc) && make install
  
else
  echo "$PKG_NAME $VER is already installed"
fi

cd $ROOT && rm -rf $TMP_DIR
