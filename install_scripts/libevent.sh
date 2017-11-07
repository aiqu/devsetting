#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

TMP_DIR=$ROOT/tmp
REPO_URL=https://github.com/libevent/libevent
TAG=$(git ls-remote --tags $REPO_URL | grep release | awk -F/ '{print $3}' | grep -v '{}' | sort -V | tail -n1)
FOLDER="libevent-$TAG"
VER=$(echo $TAG | awk -F'-' '{print $2}')
VERFILE="$HOME/.local/lib/cmake/libevent/LibeventConfigVersion.cmake"
unset INSTALLED_VERSION
if [ -r $VERFILE ];then
  INSTALLED_VERSION=$(cat $VERFILE | head -n1 | cut -d'"' -f2)
fi

if [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  echo "libevent $VER installation.. pwd: $PWD, root: $ROOT, core: $CORE"

  mkdir -p $TMP_DIR && cd $TMP_DIR

  curl -LO ${REPO_URL}/archive/${TAG}.zip
  unzip -q ${TAG}.zip
  cd $FOLDER
  mkdir -p build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local .. && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "libevent $INSTALLED_VERSION is already installed"
fi

cd $ROOT
