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
WORKDIR=$HOME/.lib/ffmpeg
BUILDDIR=$WORKDIR/build
BINDIR=$HOME/.local/bin
0
if [ $OS == 'centos' ];then
  $SUDO yum-config-manager --add-repo http://www.nasm.us/nasm.repo
  $SUDO yum install -y autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel
  cd $WORKDIR
  curl -LO http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
  tar xzvf yasm-1.3.0.tar.gz
  cd yasm-1.3.0
  ./configure --prefix="$BUILDDIR" --bindir="$BINDIR"
  make -j$(nproc)
  make install

  cd $WORKDIR
  VER=$(git ls-remote https://git.ffmpeg.org/ffmpeg.git | grep release | awk -F/ '{print $4}' | sort -t '/' -k 3 -V | tail -n1) \
  curl -LO https://ffmpeg.org/releases/ffmpeg-${VER}.tar.xz \
  tar xjvf ffmpeg-${VER}.tar.bz2 \
  cd ffmpeg-${VER}

  PKG_CONFIG_PATH="$BUILDDIR/lib/pkgconfig" ./configure \
    --prefix="$BUILDDIR" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$BUILDDIR/include" \
    --extra-ldflags="-L$BUILDDIR/lib" \
    --extra-libs=-lpthread \
    --bindir="$BINDIR" \
    --enable-gpl \
    --enable-libfreetype \
    --enable-nonfree
  make -j$(nproc)
  make install
  cd $PWD
  rm -rf $WORKDIR
fi
