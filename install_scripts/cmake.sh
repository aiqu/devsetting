#!/bin/bash

set -e

CMAKE_DONE=

if [ ! $ROOT ];then
    if [ ! -d 'install_scripts' ];then
        ROOT=$(pwd)/..
    else
        ROOT=$(pwd)
    fi
fi

if [ ! $CONFIGURATIONS_DONE ];then
    source $ROOT/install_scripts/configurations.sh
fi

echo "cmake installation.. pwd: $PWD, root: $ROOT, core: $CORE"

TMP_DIR=$ROOT/tmp
REPO_URL=https://github.com/Kitware/CMake
TAG=$(git ls-remote --tags $REPO_URL | awk -F/ '{print $3}' | grep -v -e '{}' -e 'rc' | sort -V | tail -n1)
VER=$(echo $TAG | sed 's/v//')
FOLDER="CMake-$VER"
INSTALLED_VER=$(cmake --version 2>/dev/null | grep version | awk '{print $3}')

if [ -z $INSTALLED_VER ] || [ $INSTALLED_VER != $VER ];then
  mkdir -p $TMP_DIR && cd $TMP_DIR

  curl -LO ${REPO_URL}/archive/${TAG}.zip
  unzip ${TAG}.zip
  cd $FOLDER && mkdir build && cd build
  cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local .. && make -j$(nproc) && make install

  cd $PWD
  rm -rf $TMP_DIR
else
  echo "CMake $VER is already installed"
fi

CMAKE_DONE=1
