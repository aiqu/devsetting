#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

. $ROOT/install_scripts/geos.sh
. $ROOT/install_scripts/proj4.sh
. $ROOT/install_scripts/gdal.sh
. $ROOT/install_scripts/libxml2.sh
. $ROOT/install_scripts/jsonc.sh
. $ROOT/install_scripts/postgresql.sh

PKG_NAME="postgis"
TMP_DIR=$ROOT/tmp
REPO_URL="https://github.com/postgis/postgis"
TAG=$(git ls-remote -t $REPO_URL | grep -v -e '{}\|alpha\|beta\|rc\|start\|gis\|pre' | cut -d/ -f3 | sort -V | tail -n1)
VER=""
FOLDER="$PKG_NAME*"
VERFILE=""
INSTALLED_VERSION=""

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $TAG != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $TAG installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -LO $REPO_URL/archive/$TAG.zip
  unzip -q $TAG.zip && rm -rf $TAG.zip && cd $FOLDER
  ./autogen.sh
  ./configure --prefix=$HOME/.local && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $INSTALLED_VERSION is already installed"
fi

cd $ROOT
