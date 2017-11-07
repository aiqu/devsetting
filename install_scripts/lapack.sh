#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

source $ROOT/envset.sh

PWD=$(pwd)

WORKDIR=$HOME/.lib
INSTALLDIR=$HOME/.local

cd $WORKDIR
if [ ! -d lapack-release ];then
  git clone https://github.com/Reference-LAPACK/lapack-release.git
fi
cd lapack-release && git pull && mkdir -p build && cd build && \
cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=$INSTALLDIR .. && \
make -j$(nproc) && make install
