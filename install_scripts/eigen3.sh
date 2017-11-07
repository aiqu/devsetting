#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

source $ROOT/envset.sh

PWD=$(pwd)
WORKDIR=$HOME/.lib
VER='3.3'

if [ $OS == 'centos' ]; then
  $SUDO yum install -y hg
elif [ $OS == 'ubuntu' ]; then
  $SUDO apt install -y mercurial
fi

cd $WORKDIR
if [ ! -d eigen ]; then
  hg clone https://bitbucket.org/eigen/eigen/
fi
cd eigen && hg up $VER &&  mkdir -p build && cd build && \
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local .. && \
make install
