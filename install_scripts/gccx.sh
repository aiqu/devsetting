#!/bin/bash
#
#    GCC install function
#
#    Copyright (C) 2018 Gwangmin Lee
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

. $ROOT/envset.sh

. $ROOT/install_scripts/texinfo.sh

function install_gcc() {
  if [ $# != 1 ];then
    eecho "install_gcc require exactly one argument"
    return 1
  fi

  VER=$1
  VER_STR=$(echo $VER | sed 's/_/./g')
  MAJOR_VER=$(echo $VER | cut -d'_' -f1)
  SUFFIX="-$MAJOR_VER"

  if [ -f ${LOCAL_DIR}/bin/gcc$SUFFIX ] && [ $(${LOCAL_DIR}/bin/gcc$SUFFIX --version | sed -n '1p' | cut -d' ' -f3) == $VER_STR ];then
    gecho "gcc $VER is already installed"
    return 0
  fi

  iecho "GCC $VER installation.. install location: $LOCAL_DIR"
  CFLAGS="-O2 -pipe"

  WORKDIR=$HOME/.lib/gcc-$VER
  GCC_SOURCE_DIR="$WORKDIR/gcc-gcc-$VER-release"
  GCC_BUILD_DIR="$WORKDIR/gcc-build"
  GMP="gmp-6.1.2"
  MPFR="mpfr-3.1.6"
  MPC="mpc-1.0.3"
  ISL="isl-0.16.1"

  mkdir -p $WORKDIR && cd $WORKDIR
  if [ ! -d $GCC_SOURCE_DIR ];then
    curl -LO https://github.com/gcc-mirror/gcc/archive/gcc-$VER-release.zip && unzip -q gcc-$VER-release.zip
  fi
  cd $GCC_SOURCE_DIR
  if [ ! -d gmp ]; then
    curl -L https://gmplib.org/download/gmp/$GMP.tar.xz | tar xJf -
    mv $GMP gmp
  fi
  if [ ! -d mpfr ]; then
    curl -L http://www.mpfr.org/$MPFR/$MPFR.tar.xz | tar xJf -
    mv $MPFR mpfr
  fi
  if [ ! -d mpc ]; then
    curl -L ftp://ftp.gnu.org/gnu/mpc/$MPC.tar.gz | tar xzf -
    mv $MPC mpc
  fi
  if [ ! -d isl ]; then
    curl -L ftp://gcc.gnu.org/pub/gcc/infrastructure/$ISL.tar.bz2 | tar xjf -
    mv $ISL isl
  fi
  export CLFAGS=$CFLAGS CXXFLAGS=$CFLAGS
  mkdir -p $GCC_BUILD_DIR && cd $GCC_BUILD_DIR
  $GCC_SOURCE_DIR/configure \
    --prefix=${LOCAL_DIR} \
    --disable-multilib \
    --with-arch=core2 \
    --with-language=c,c++,fortran,go \
    --program-suffix=$SUFFIX
  make -s -j$(nproc)
  make -s install-strip 1>/dev/null
  unset CFLAGS CXXFLAGS
  cd $ROOT && rm -rf $WORKDIR
  ls ${LOCAL_DIR}/bin/*$SUFFIX | sed 's/\(.\+\)'$SUFFIX'/\0 \1/' | xargs -n2 ln -fs
}
