#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

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
  ./configure --prefix=$HOME/.local --enable-widec --with-shared && \
    make -j$(nproc) && make install
fi

cd $ROOT
