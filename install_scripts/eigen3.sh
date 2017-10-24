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
VER='3.3'

if [ $OS == 'centos' ]; then
  $SUDO yum install -y hg
elif [ $OS == 'ubuntu' ]; then
  $SUDO apt install -y hg
fi

cd $WORKDIR
if [ ! -d eigen ]; then
  hg clone https://bitbucket.org/eigen/eigen/
fi
cd eigen && hg up $VER &&  mkdir -p build && cd build && \
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local .. && \
make install
