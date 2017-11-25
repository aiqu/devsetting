#!/bin/bash
#
#    postgis installer
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

. $ROOT/install_scripts/geos.sh
. $ROOT/install_scripts/proj4.sh
. $ROOT/install_scripts/gdal.sh
. $ROOT/install_scripts/libxml2.sh
. $ROOT/install_scripts/jsonc.sh
. $ROOT/install_scripts/postgresql.sh

PKG_NAME="postgis"
TMP_DIR=$ROOT/tmp
REPO_URL="https://github.com/postgis/postgis"
TAG=$(git ls-remote -t $REPO_URL | grep -v -e '{}\|alpha\|beta\|rc\|start\|gis\|pre' | cut -d/ -f3 | sort -V | tail -n1)
VER=""
FOLDER="$PKG_NAME*"
VERFILE=""
INSTALLED_VERSION=""

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $TAG != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $TAG installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -LO $REPO_URL/archive/$TAG.zip
  unzip -q $TAG.zip && rm -rf $TAG.zip && cd $FOLDER
  ./autogen.sh
  ./configure -q --prefix=$HOME/.local && \
    make -s -j$(nproc) && make -s install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $INSTALLED_VERSION is already installed"
fi

cd $ROOT
