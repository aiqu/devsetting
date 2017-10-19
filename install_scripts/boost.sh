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
  $SUDO yum install -y xz-devel
elif [ $OS == 'ubuntu' ];then
  $SUDO apt install -y liblzma-dev
elif [ $OS == 'macos' ];then
  brew install xz
fi

cd $WORKDIR
VER='1.65.1'
VERSTR='1_65_1'
SRCFILE="boost_$VERSTR.tar.bz2"
if [ ! -d boost_$VERSTR ];then
  if [ ! -f $SRCFILE ]; then
    curl -L https://dl.bintray.com/boostorg/release/$VER/source/$SRCFILE | tar xjf -
  fi
fi
cd boost_$VERSTR
./bootstrap.sh --prefix=$HOME/.local
./b2 -j$(nproc) && ./b2 install
