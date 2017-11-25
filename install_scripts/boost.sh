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

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

source $ROOT/envset.sh

PWD=$(pwd)
WORKDIR=$HOME/.lib

. $ROOT/install_scripts/xz.sh
. $ROOT/install_scripts/cmake.sh

cd $WORKDIR
VER='1.65.1'
VERSTR='1_65_1'
SRCFILE="boost_$VERSTR.tar.bz2"
REQUIRED_CMAKE_VER='3.9.3'
INSTALLED_CMAKE_VER=$(cmake --version 2>/dev/null | head -n1 | awk '{print $3}')
if [ ! $REQUIRED_CMAKE_VER == "$(echo -e "$INSTALLED_CMAKE_VER\n$REQUIRED_CMAKE_VER" | sort -V | head -n1)" ]; then
  echo "Require CMake $REQUIRED_CMAKE_VER ( $INSTALLED_CMAKE_VER installed)"
fi

if [ ! -d boost_$VERSTR ];then
  if [ ! -f $SRCFILE ]; then
    echo "Downloading Boost $VER"
    curl -L https://dl.bintray.com/boostorg/release/$VER/source/$SRCFILE | tar xjf -
  fi
fi
cd boost_$VERSTR
./bootstrap.sh --prefix=$HOME/.local
./b2 -j$(nproc) && ./b2 install
