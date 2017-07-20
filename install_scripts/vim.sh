#!/bin/bash

PWD=$(pwd)
REPO=repo

cd $REPO/vim
make -j$(cat /proc/cpuinfo | grep processor | wc -l) && sudo make install
cd $PWD
