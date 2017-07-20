#!/bin/bash

set -e
PWD=$(pwd)

TAG=2.14.0-rc0

mkdir tmp
cd tmp
FILENAME=v${TAG}.zip
curl -LO https://github.com/git/git/archive/${FILENAME}
unzip ${FILENAME}
cd git-${TAG}
make --prefix=${HOME}/bin -j$(cat /proc/cpuinfo | grep processor | wc -l) all && make install
cd $PWD
rm -rf tmp
