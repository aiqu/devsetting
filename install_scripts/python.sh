#!/bin/bash

set -e

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
make -j$(cat /proc/cpuinfo | grep processors | wc -l)
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
make -j$(cat /proc/cpuinfo | grep processors | wc -l)
make test
make altinstall
