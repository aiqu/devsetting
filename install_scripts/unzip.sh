#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="unzip"
TMP_DIR=$ROOT/tmp
REPO_URL="https://downloads.sourceforge.net/infozip/unzip60.tar.gz"
FOLDER="$PKG_NAME*"

if [ ! -f $HOME/.local/bin/unzip ]; then
  echo "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL | tar xz && cd $FOLDER
  if [ $OS == 'mac' ]; then
    make -f macos/Makefile -j$(nproc) generic
  else
    make -f unix/Makefile -j$(nproc) generic
  fi
    make prefix=$HOME/.local MANDIR=$HOME/.local/share/man/man1 -f unix/Makefile install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $VER is already installed"
fi

cd $ROOT
