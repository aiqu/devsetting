#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

source $ROOT/envset.sh

PWD=$(pwd)
WORKDIR=$HOME/.lib

cd $WORKDIR
REPO_URL=https://github.com/mariusmuja/flann
TAG=$(git ls-remote --tags $REPO_URL | awk -F/ '{print $3}' | grep -v '{}' | grep -v '-' | sort -V | tail -n1)
FOLDER="flann-${TAG}"
if [ ! -d $FOLDER ]; then 
  echo "Downloading Flann $TAG"
  curl -LO $REPO_URL/archive/${TAG}.zip
  unzip -q ${TAG}.zip && rm -rf ${TAG}.zip
fi
cd $FOLDER && mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME/.local ..
make -j$(nproc) && make install
