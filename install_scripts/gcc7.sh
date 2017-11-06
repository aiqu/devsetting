#!/bin/bash

set -e

if [ ! $ROOT ];then
    if [ ! -d 'install_scripts' ];then
        ROOT=$(pwd)/..
    else
        ROOT=$(pwd)
    fi
fi

if [ ! $CONFIGURATIONS_DONE ];then
    source $ROOT/install_scripts/configurations.sh
fi

echo "gcc installation.. pwd: $PWD, root: $ROOT, core: $CORE"
CFLAGS="-O2 -pipe"

VER='7_2_0'
VER_STR=$(echo $VER | sed 's/_/./g')
WORKDIR=$HOME/.lib/gcc-$VER
GCC_SOURCE_DIR="$WORKDIR/gcc-gcc-$VER-release"
GCC_BUILD_DIR="$WORKDIR/gcc-build"
GMP="gmp-6.1.2"
MPFR="mpfr-3.1.6"
MPC="mpc-1.0.3"
ISL="isl-0.16.1"

if [ -f $HOME/.local/bin/gcc-7 ] && [ $($HOME/.local/bin/gcc-7 --version | sed -n '1p' | cut -d' ' -f3) == $VER_STR ];then
  echo "gcc $VER_STR is already installed"
  exit 0
fi

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
  curl -L http://www.mpfr.org/mpfr-current/$MPFR.tar.xz | tar xJf -
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
export CLFAGS=$CFLAGS CXXFLAGS=$CFLAGS && \
  mkdir -p $GCC_BUILD_DIR && \
  cd $GCC_BUILD_DIR && \
  $GCC_SOURCE_DIR/configure --prefix=$HOME/.local --disable-multilib --with-arch=core2 --with-language=c,c++,fortran,go --program-suffix=-7 && \
  make -j$(nproc) && \
  make install
