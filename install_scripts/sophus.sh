#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

source $ROOT/envset.sh

PWD=$(pwd)
WORKDIR=$HOME/.lib

cd $WORKDIR
if [ ! -d Sophus ]; then
  git clone https://github.com/strasdat/Sophus.git
fi
cd Sophus && git pull && mkdir -p build && cd build && \
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME/.local .. && \
make -j$(nproc) && make install
