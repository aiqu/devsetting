#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="gdal"
TMP_DIR=$ROOT/tmp
REPO_URL="http://download.osgeo.org/gdal/2.2.2/gdal-2.2.2.tar.gz"
TAG=$(echo $REPO_URL | cut -d'/' -f5)
VER=$TAG
FOLDER="$PKG_NAME*"
VERFILE="$HOME/.local/include/gdal_version.h"
INSTALLED_VERSION=$(cat $VERFILE | grep -e 'define GDAL_RELEASE_NAME' | cut -d'"' -f2)

if [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $TAG installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL | tar xz && cd $FOLDER
  ./autogen.sh
  ./configure --prefix=$HOME/.local && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $VER is already installed"
fi

cd $ROOT
