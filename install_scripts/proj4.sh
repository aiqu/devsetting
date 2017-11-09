#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="proj4"
TMP_DIR=$ROOT/tmp
TAG='4.9.3'
VER=$(echo $TAG | sed 's/\.//g')
REPO_URL="http://download.osgeo.org/proj/proj-$TAG.tar.gz"
FOLDER="proj*"
VERFILE="$HOME/.local/include/proj_api.h"
INSTALLED_VERSION=$(cat $VERFILE | grep -e 'define PJ_VERSION ' | cut -d' ' -f3)

if [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $TAG installation.. pwd: $PWD, root: $ROOT, core: $CORE"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL | tar xz && cd $FOLDER
  ./configure --prefix=$HOME/.local && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $TAG is already installed"
fi

cd $ROOT
