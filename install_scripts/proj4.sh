#!/bin/bash
#
#    proj4 installer
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

PKG_NAME="proj4"
TMP_DIR=$ROOT/tmp
TAG='4.9.3'
VER=$(echo $TAG | sed 's/\.//g')
REPO_URL="http://download.osgeo.org/proj/proj-$TAG.tar.gz"
FOLDER="proj*"
VERFILE="$HOME/.local/include/proj_api.h"
INSTALLED_VERSION=$(cat $VERFILE | grep -e 'define PJ_VERSION ' | cut -d' ' -f3)

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $TAG installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL | tar xz && cd $FOLDER
  ./configure --prefix=$HOME/.local && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $TAG is already installed"
fi

cd $ROOT
