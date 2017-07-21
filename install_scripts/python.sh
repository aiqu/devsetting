#!/bin/bash

PYTHONE_DONE=

set -e

if [ ! -d configurations ];then
	ROOT=$(pwd)/..
else
	ROOT=$(pwd)
fi

if [ ! $CONFIGURATIONS_DONE ];then
    $($ROOT/install_scripts/configurations.sh)
fi

echo "Git installation.. pwd: $PWD, root: $ROOT"

PWD=$(pwd)

mkdir -p $HOME/.lib

VERSION=3.6.2
cd $HOME/.lib
if [ ! -f Python-$VERSION.tgz ];then
    wget https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tgz
    tar -xvf Python-$VERSION.tgz
fi
cd Python-$VERSION
./configure --prefix=$HOME/bin
make -j$CORE
make test
make install

VERSION=2.7.13
cd $HOME/.lib
if [ ! -f Python-$VERSION.tgz ];then
    wget https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tgz
    tar -xvf Python-$VERSION.tgz
fi
cd Python-$VERSION
./configure --prefix=$HOME/bin
make -j$CORE
make test
make altinstall

PYTHONE_DONE=1
