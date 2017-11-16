#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
. $ROOT/envset.sh

bash $ROOT/install_scripts/tmux.sh

REPO_URL=https://github.com/aiqu/byobu

echo "Byobu installation.. pwd: $PWD, root: $ROOT"

mkdir -p $HOME/.lib && cd $HOME/.lib

if [ ! -d byobu ];then
  git clone --depth=1 $REPO_URL
fi

cd byobu && git pull && \
./autogen.sh && ./configure --prefix="$HOME/.local" && \
make -j$(nproc) && make install

cd $ROOT
