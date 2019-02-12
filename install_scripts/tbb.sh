#!/usr/bin/env bash
#
#    TBB (Thread building block) installer
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

FILENAME=`basename ${BASH_SOURCE[0]}`
FILENAME=${FILENAME%%.*}
DONENAME="DONE$FILENAME"
if [ ! -z ${!DONENAME+x} ];then
  return 0
fi
let DONE$FILENAME=1

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="tbb"
REPO_URL="https://github.com/01org/tbb"
TAG=$(git ls-remote -t $REPO_URL | cut -d/ -f3 | grep 20 | sort -V | tail -n1)
CUSTOMTAGNAME="${PKG_NAME}TAG"
TAG=${!CUSTOMTAGNAME:-$TAG}
VER="2019.0.10003"
FOLDER="$PKG_NAME*"
VERFILE="${LOCAL_DIR}/include/tbb/tbb_stddef.h"
INSTALLED_VERSION=
if [ -r $VERFILE ];then
  MAJOR=$(cat $VERFILE | grep -m1 TBB_VERSION_MAJOR | cut -d' ' -f3)
  MINOR=$(cat $VERFILE | grep -m1 TBB_VERSION_MINOR | cut -d' ' -f3)
  INTERFACE=$(cat $VERFILE | grep -m1 TBB_INTERFACE_VERSION | cut -d' ' -f3)
  INSTALLED_VERSION="${MAJOR}.${MINOR}.${INTERFACE}"
fi

if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_VERSION ] || $(compare_version $INSTALLED_VERSION $VER); then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl --retry 10 -L $REPO_URL/archive/$TAG.tar.gz | tar xz
  cd $FOLDER
  python build/build.py --prefix=${LOCAL_DIR} --install-libs --install-devel

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

LEVEL=$(( ${LEVEL}-1 ))
cd $ROOT
