#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

source $ROOT/envset.sh

PWD=$(pwd)
WORKDIR=$HOME/.lib/ffmpeg
BUILDDIR=$WORKDIR/build
BINDIR=$HOME/.local/bin

if [ $OS == 'centos' ];then
  #$SUDO yum-config-manager --add-repo http://www.nasm.us/nasm.repo
  #$SUDO yum install -y autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel
  #mkdir -p $WORKDIR && cd $WORKDIR
  #curl -L http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz | tar xzf -
  #cd yasm-1.3.0
  #./configure --prefix="$BUILDDIR" --bindir="$BINDIR"
  #make -j$(nproc)
  #make install

  cd $WORKDIR
  TAG=$(git ls-remote https://git.ffmpeg.org/ffmpeg.git | awk -F/ '{print $3}' | grep -v -e '{}' -e '-' -e 'v' -e 'release' -e 'oldabi' | sort -V | tail -n1)
  VER=$(echo $TAG | sed 's/n//')
  curl -L https://ffmpeg.org/releases/ffmpeg-${VER}.tar.xz | tar xJf -
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
  rm -rf $WORKDIR
fi
