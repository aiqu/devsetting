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

elif [ $OS == 'ubuntu' ];then

fi
REPO_URL=https://github.com/PointCloudLibrary/pcl
TAG=$(git ls-remote --tags $REPO_URL | awk -F/ '{print $3}' | grep -v -e '{}' -e '-' | sort -t '/' -k 3 -V | tail -n1)
if [ ! -d pcl-${TAG} ];then
  curl -LO ${REPO_URL}/archive/${TAG}.zip
  unzip ${TAG}.zip && rm ${TAG}.zip
fi
cd pcl-${TAG} && mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME/.local ..
make -j && make install
