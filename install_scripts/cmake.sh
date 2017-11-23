#!/bin/bash

set -e

CMAKE_DONE=

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
. $ROOT/envset.sh

echo "cmake installation.. pwd: $PWD, root: $ROOT"

TMP_DIR=$ROOT/tmp
REPO_URL=https://github.com/Kitware/CMake
TAG=$(git ls-remote --tags $REPO_URL | awk -F/ '{print $3}' | grep -v -e '{}' -e 'rc' | sort -V | tail -n1)
VER=$(echo $TAG | sed 's/v//')
FOLDER="CMake-$VER"
INSTALLED_VER=$(cmake --version 2>/dev/null | grep version | awk '{print $3}')

if [ -z $INSTALLED_VER ] || [ $INSTALLED_VER != $VER ];then
  mkdir -p $TMP_DIR && cd $TMP_DIR

  echo "Downloading CMake $VER"
  curl -LO ${REPO_URL}/archive/${TAG}.zip
  unzip -q ${TAG}.zip
  cd $FOLDER
  ./bootstrap --prefix=$HOME/.local --parallel=$(nproc) --no-system-libs --system-libarchive --system-expat

  make -j$(nproc) && make install

  cd $PWD
  rm -rf $TMP_DIR
else
  echo "CMake $VER is already installed"
fi

cd $ROOT

CMAKE_DONE=1
