#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

TMP_DIR=$ROOT/tmp
REPO_URL=https://github.com/dustinkirkland/byobu

echo "Byobu installation.. pwd: $PWD, root: $ROOT, core: $CORE"

cd $HOME/.lib

if [ ! -d byobu ];then
  git clone $REPO_URL
fi

cd byobu && git pull && \
./autogen.sh && ./configure --prefix="$HOME/.local" && \
make -j$(nproc) && make install

cd $ROOT
