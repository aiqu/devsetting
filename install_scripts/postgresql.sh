#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

TMP_DIR=$ROOT/tmp
REPO_URL=https://ftp.postgresql.org/pub/source/v10.0/postgresql-10.0.tar.bz2
BIN=$HOME/.local/bin/postgres
if [ -f $BIN ];then
  INSTALLED_VERSION=$($BIN -V | cut -d' ' -f3)
  echo "Postgresql $INSTALLED_VERSION is already installed"
else
  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL | tar xj && cd postgresql*
  ./configure --prefix=$HOME/.local && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
fi

cd $ROOT
