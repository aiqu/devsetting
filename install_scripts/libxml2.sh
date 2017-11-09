#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="libxml2"
TMP_DIR=$ROOT/tmp
REPO_URL="http://github.com/GNOME/libxml2"
TAG=$(git ls-remote -t $REPO_URL | grep -v -e '{}\|rc' | cut -d/ -f3 | sort -V | tail -n1)
VER=$(echo $TAG | sed 's/v//g')
FOLDER="$PKG_NAME*"
VERFILE="$HOME/.local/include/libxml2/libxml/xmlversion.h"
INSTALLED_VERSION=$(cat $VERFILE | grep -e 'define LIBXML_DOTTED_VERSION "' | cut -d'"' -f2)

if [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $TAG installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -LO $REPO_URL/archive/$TAG.zip && \
    unzip -q $TAG.zip && rm $TAG.zip && cd $FOLDER
  ./autogen.sh
  ./configure --prefix=$HOME/.local && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $VER is already installed"
fi

cd $ROOT
