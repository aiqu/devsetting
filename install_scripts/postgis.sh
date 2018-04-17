#!/usr/bin/env bash
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

. $ROOT/install_scripts/geos.sh
. $ROOT/install_scripts/proj4.sh
. $ROOT/install_scripts/gdal.sh
. $ROOT/install_scripts/libxml2.sh
. $ROOT/install_scripts/jsonc.sh
. $ROOT/install_scripts/postgresql.sh

PKG_NAME="postgis"
REPO_URL="https://github.com/postgis/postgis"
TAG=$(git ls-remote -t $REPO_URL | grep -v -e '{}\|alpha\|beta\|rc\|start\|gis\|pre' | cut -d/ -f3 | sort -V | tail -n1)
VER=$(echo $TAG | awk -F'.' '{print $1 "." $2}')
FOLDER="$PKG_NAME*"
VERFILE=""
INSTALLED_VERSION=$(basename -a -s .so $(find ${LOCAL_DIR}/lib/postgresql -name 'postgis-*' -type f) | cut -d'-' -f2 | sort -V | tail -n1)

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -LO $REPO_URL/archive/$TAG.zip
  unzip -q $TAG.zip && rm -rf $TAG.zip && cd $FOLDER
  ./autogen.sh
  ./configure --prefix=${LOCAL_DIR}
  make -s -j$(nproc)
  make -s install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

cd $ROOT
