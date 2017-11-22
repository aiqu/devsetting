#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="openssl"
TMP_DIR=$ROOT/tmp
REPO_URL="https://github.com/openssl/openssl"
TAG=$(git ls-remote -t $REPO_URL | grep -v -e '{}\|pre\|FIPS' | grep OpenSSL | cut -d/ -f3 | sort -V | tail -n1)
VER=$(echo $TAG | sed 's/OpenSSL.//' | sed 's/_/./g')
FOLDER="$PKG_NAME*"
VERFILE=""
#INSTALLED_VERSION=$(openssl version | cut -d' ' -f2)

if [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL/archive/$TAG.tar.gz | tar xz && cd $FOLDER
  ./config --prefix=$HOME/.local --openssldir=$HOME/.local/ssl threads no-shared && \
    make -j$(nproc) && make install_sw && make install_man_docs

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $VER is already installed"
fi

cd $ROOT
