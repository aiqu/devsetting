#!/bin/bash

set -e
PWD=$(pwd)

if [[ -d repo ]];then
    ROOT=$PWD
else
    ROOT=$(readlink -f ..)
fi

TAG=2.14.0-rc0

mkdir -p $HOME/.lib
cd $HOME/.lib
FILENAME=v${TAG}.zip
if [ ! -f $FILENAME ];then
    curl -LO https://github.com/git/git/archive/${FILENAME}
fi
unzip ${FILENAME}
cd git-${TAG}
make prefix=${HOME}/bin -j$(cat /proc/cpuinfo | grep processor | wc -l) all && make install
cd $PWD
