#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

TMP_DIR=$ROOT/tmp

#slang library installation
VERFILE="$HOME/.local/include/slang.h"
if [ ! -f $VERFILE ];then
  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L ftp://space.mit.edu/pub/davis/slang/v2.1/slang-2.1.4.tar.gz | tar xz
  cd slang-2.1.4 && ./configure --prefix=$HOME/.local && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  VER=$(cat $VERFILE | grep -e 'define SLANG_VERSION_STRING "' | cut -d'"' -f2)
  echo "Slang $VER is already installed"
fi

VERFILE="$HOME/.local/include/popt.h"
if [ ! -f $VERFILE ];then
  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L http://rpm5.org/files/popt/popt-1.16.tar.gz | tar xz
  cd popt-1.16 && ./configure --prefix=$HOME/.local && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "popt is already installed"
fi


REPO_URL=https://pagure.io/newt.git
TAG=$(git ls-remote -t $REPO_URL | cut -d'/' -f3 | grep -v v | sort -V | tail -n1)
VER=$(echo $TAG | sed 's/[r|.zip]//g' | sed 's/-/./g')
FOLDER="newt-$VER"
INSTALLED_VER=$(find $HOME/.local/lib -mindepth 1 -maxdepth 1 -type f | grep newt.so | sed 's/.*libnewt.so.//')
if [ -z $INSTALLED_VER ] || [ $VER != $INSTALLED_VER ];then
  mkdir -p $TMP_DIR && cd $TMP_DIR
  DOWN_URL=https://releases.pagure.org/newt/newt-$VER.tar.gz
  curl -L $DOWN_URL | tar xz && cd $FOLDER
  ./configure --prefix=$HOME/.local && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "ncurses $INSTALLED_VER is already installed"
fi

cd $ROOT
