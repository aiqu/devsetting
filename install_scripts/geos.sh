#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="geos"
TMP_DIR=$ROOT/tmp
REPO_URL="http://git.osgeo.org/gogs/geos/geos"
TAG=$(git ls-remote -t $REPO_URL | grep -v -e '{}\|rc\|rel\|start\|beta' | cut -d/ -f3 | sort -V | tail -n1)
VER=""
FOLDER="$PKG_NAME*"
VERFILE="$HOME/.local/include/geos_c.h"
INSTALLED_VERSION=$(cat $VERFILE | grep -e 'define GEOS_VERSION "' | cut -d'"' -f2)

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $TAG != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $TAG installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL/archive/$TAG.tar.gz | tar xz && cd $FOLDER
  mkdir -p build && cd build
  cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Release -DGEOS_ENABLE_TESTS=OFF .. && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $INSTALLED_VERSION is already installed"
fi

cd $ROOT
