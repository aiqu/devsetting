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
WORKDIR=$HOME/.lib

if [ $OS == 'centos' ];then
	$SUDO yum install -y autoconf automake curl make unzip
elif [ $OS == 'ubuntu' ];then
	$SUDO apt-get install -y autoconf automake libtool curl make g++ unzip
fi

cd $WORKDIR
REPO_URL=https://github.com/google/protobuf
#TAG=$(git ls-remote --tags $REPO_URL | awk -F/ '{print $3}' | grep -v '{}' | sort -t '/' -k 3 -V | tail -n1)
TAG='v3.4.0'
VER=$(echo $TAG | sed 's/v//' -)
INSTALLED_VER=$(protoc --version | awk '{print $2}')
if [ ! $VER == $INSTALLED_VER ]; then
  echo "RUN installation"
  curl -LO ${REPO_URL}/archive/${TAG}.zip
  unzip ${TAG}.zip && rm -rf ${TAG}.zip protobuf
  mv protobuf-$VER protobuf
  cd protobuf && 
    ./autogen.sh && ./configure --prefix=$HOME/.local
    make -j$(nproc) && make check -j$(nproc) && make install
fi
