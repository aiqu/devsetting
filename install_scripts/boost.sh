#!/bin/bash
#
#    Boost installer
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

FILENAME=`basename ${BASH_SOURCE[0]}`
FILENAME=${FILENAME%%.*}
DONENAME="DONE$FILENAME"
if [ ! -z ${!DONENAME+x} ];then
  return 0
fi
let DONE$FILENAME=1

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

source $ROOT/envset.sh

PWD=$(pwd)
WORKDIR=$HOME/.lib

. $ROOT/install_scripts/xz.sh
. $ROOT/install_scripts/cmake.sh

PKG_NAME="boost"
mkdir -p $WORKDIR && cd $WORKDIR
VER='1.65.1'
VERSTR='1_65_1'
SRCFILE="boost_$VERSTR.tar.bz2"
VERFILE=${LOCAL_DIR}/include/boost/version.hpp
if [ -r $VERFILE ];then
  INSTALLED_VERSION=$(grep 'BOOST_LIB_VERSION "' $VERFILE | cut -d'"' -f2)
fi

if [ ! -z $REINSTALL ] || [ $VERSTR != $INSTALLED_VERSION ];then
  iecho "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"
  if [ ! -d boost_$VERSTR ];then
    if [ ! -f $SRCFILE ]; then
      iecho "Downloading Boost $VER"
      curl -L https://dl.bintray.com/boostorg/release/$VER/source/$SRCFILE | tar xjf -
    fi
  fi
  cd boost_$VERSTR
  ./bootstrap.sh --prefix=${LOCAL_DIR}
  ./b2 -j$(nproc)
  ./b2 install
else
  gecho "$PKG_NAME $VER is already installed"
fi

cd $ROOT
