#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="pkg-config"
TMP_DIR=$ROOT/tmp
REPO_URL="git://anongit.freedesktop.org/pkg-config"
TAG=$(git ls-remote -t $REPO_URL | grep -v {} | cut -d/ -f3 | sort -V | tail -n1)
VER=$(echo $TAG | sed 's/pkg-config-//')
FOLDER="$PKG_NAME*"
VERFILE=""
set +e
INSTALLED_VERSION=$(pkg-config --version 2>/dev/null)
set -e

if [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  git clone $REPO_URL --branch $TAG --depth=1
  cd $FOLDER
  ./autogen.sh --prefix=$HOME/.local --with-internal-glib && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $VER is already installed"
fi

cd $ROOT
