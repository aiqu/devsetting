#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
. $ROOT/envset.sh

TMP_DIR=$ROOT/tmp
REPO_URL=http://invisible-island.net/datafiles/release/ncurses.tar.gz
FOLDER='ncurses'
VERFILE="$HOME/.local/include/ncursesw/curses.h"
if [ -r $VERFILE ];then
  INSTALLED_VERSION=$(cat $VERFILE | grep -e 'define NCURSES_VERSION ' | cut -d'"' -f2)
  echo "ncurses $INSTALLED_VERSION is already installed"
else
  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL | tar xz && cd ncurses*
  ./configure --prefix=$HOME/.local --enable-widec --without-develop --without-cxx-binding --with-shared CPPFLAGS='-P' && \
    make -j$(nproc) && make install
  ln -sf $HOME/.local/include/ncursesw/*.h $HOME/.local/include/
  ln -sf libncursesw.so $HOME/.local/lib/libcurses.so

  cd $ROOT && rm -rf $TMP_DIR
fi

cd $ROOT
