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

if [ $OS == 'centos' ];then
  $SUDO yum install -y libXt-devel
elif [ $OS == 'ubuntu' ];then
  $SUDO apt install -y libxt-dev
fi

WORKDIR=$HOME/.lib

cd $WORKDIR
REPO_URL=https://gitlab.kitware.com/vtk/vtk
TAG=$(git ls-remote --tags $REPO_URL | awk -F/ '{print $3}' | grep -v -e '{}' -e 'rc' | sort -t '/' -k 3 -V | tail -n1)
COMMIT_HASH=$(git ls-remote --tags $REPO_URL | grep "$TAG^{}" | awk '{print $1}')
SRCDIR="vtk-$TAG-$COMMIT_HASH"
if [ ! -d $SRCDIR ]; then
  curl -L https://gitlab.kitware.com/vtk/vtk/repository/$TAG/archive.tar.bz2 | tar xjf -
fi
cd $SRCDIR && mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME/.local ..
make -j$(nproc) && make install
