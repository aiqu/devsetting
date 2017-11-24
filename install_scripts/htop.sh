#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="htop"
TMP_DIR=$ROOT/tmp
REPO_URL="https://github.com/hishamhm/htop"
TAG=$(git ls-remote -t $REPO_URL | grep -v {} | cut -d/ -f3 | sort -V | tail -n1)
VER=$TAG
DOWN_URL="https://hisham.hm/htop/releases/$VER/htop-$VER.tar.gz"
FOLDER="$PKG_NAME*"
VERFILE=""
if [ -f $HOME/.local/bin/htop ];then
  INSTALLED_VERSION=$(htop --version | head -n1 | cut -d' ' -f2)
fi

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $DOWN_URL | tar xz && cd $FOLDER
  ./configure --prefix=$HOME/.local && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $VER is already installed"
fi

cd $ROOT
