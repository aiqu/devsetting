#!/bin/bash
#
#    Geos installer
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
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="geos"
TMP_DIR=$ROOT/tmp
REPO_URL="http://git.osgeo.org/gogs/geos/geos"
TAG=$(git ls-remote -t $REPO_URL | grep -v -e '{}\|rc\|rel\|start\|beta' | cut -d/ -f3 | sort -V | tail -n1)
VER=""
FOLDER="$PKG_NAME*"
VERFILE="$HOME/.local/include/geos_c.h"
INSTALLED_VERSION=$(cat $VERFILE | grep -e 'define GEOS_VERSION "' | cut -d'"' -f2)

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $TAG != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $TAG installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL/archive/$TAG.tar.gz | tar xz && cd $FOLDER
  mkdir -p build && cd build
  cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Release -DGEOS_ENABLE_TESTS=OFF .. && \
    make -s -j$(nproc) && make -s install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $INSTALLED_VERSION is already installed"
fi

cd $ROOT
