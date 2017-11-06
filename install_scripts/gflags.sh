#!/bin/bash

set -e

if [ ! $ROOT ];then
    if [ ! -d 'install_scripts' ];then
        ROOT=$(pwd)/..
    else
        ROOT=$(pwd)
    fi
fi

source $ROOT/envset.sh

PWD=$(pwd)
WORKDIR=$HOME/.lib

cd $WORKDIR
if [ ! -d gflags ]; then
  git clone https://github.com/gflags/gflags
fi
cd gflags
LATEST_TAG=$(git tag | sort -V | tail -n1)
TAG='v2.1.2'
git checkout $TAG && mkdir -p build && cd build && \
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local .. && \
make -j$(nproc) && make install
