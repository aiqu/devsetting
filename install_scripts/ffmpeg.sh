#!/bin/bash
#
#    FFmpeg installer
#
#    Copyright (C) 2017 Gwangmin Lee
#    
#    Author: Gwangmin Lee <gwangmin0123@gmail.com>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

source $ROOT/envset.sh

PWD=$(pwd)
WORKDIR=$HOME/.lib/ffmpeg
BUILDDIR=$WORKDIR/build
BINDIR=$HOME/.local/bin

if [ $OS == 'centos' ];then
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
