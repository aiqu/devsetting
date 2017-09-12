#!/bin/bash

set -e

CMAKE_DONE=

if [ ! $ROOT ];then
    if [ ! -d 'install_scripts' ];then
        ROOT=$(pwd)/..
    else
        ROOT=$(pwd)
    fi
fi

if [ ! $CONFIGURATIONS_DONE ];then
    source $ROOT/install_scripts/configurations.sh
fi

echo "cmake installation.. pwd: $PWD, root: $ROOT, core: $CORE"

REPO=$ROOT/repo

cd $ROOT
git submodule init
git submodule update
cd $REPO/cmake
if [ ! -z ${REINSTALL_CMAKE+x} ];then
    make uninstall
    make clean
fi
./bootstrap --prefix=$HOME/.local
make -j$CORE && make install

cd $PWD

CMAKE_DONE=1
