#!/usr/bin/env bash
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

PKG_NAME="boost"
CUSTOMTAGNAME="${PKG_NAME}TAG"
TAG=${!CUSTOMTAGNAME:-'1.67.0'}
VER=$(echo $TAG | sed 's/\./_/g')
VERSTR=$(echo $VER | sed 's/_0//')
FOLDER="$PKG_NAME*"
SRCFILE="boost_$VER.tar.bz2"
INSTALLED_VERSION=""
if cmake --find-package -DNAME=Boost -DCOMPILER_ID=GNU -DLANGUAGE=C -DMODE=EXIST 2>&1 1>/dev/null;then
  INCLUDE_DIR=$(cmake --find-package -DNAME=Boost -DCOMPILER_ID=GNU -DLANGUAGE=C -DMODE=COMPILE | sed 's/-I//' | tr -d '[:space:]')
  VERFILE="${INCLUDE_DIR}/boost/version.hpp"
  INSTALLED_VERSION=$(grep 'BOOST_LIB_VERSION "' $VERFILE | cut -d'"' -f2)
fi

if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_VERSION ]; then
  iecho "$PKG_NAME $TAG installation.. install location: $LOCAL_DIR"
  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L https://sourceforge.net/projects/boost/files/boost/$TAG/$SRCFILE/download | tar xjf -
  cd $FOLDER
  ./bootstrap.sh --prefix=${LOCAL_DIR} --libdir=${LOCAL_DIR}/lib64 --without-libraries=python
  ./b2 -j${NPROC}
  ./b2 install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $INSTALLED_VERSION is already installed"
fi

LEVEL=$(( ${LEVEL}-1 ))
cd $ROOT
