#!/bin/bash
#
#    gdal installer
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
. $ROOT/install_scripts/jsonc.sh

PKG_NAME="gdal"
TMP_DIR=$ROOT/tmp
REPO_URL="http://download.osgeo.org/gdal/2.2.2/gdal-2.2.2.tar.gz"
TAG=$(echo $REPO_URL | cut -d'/' -f5)
VER=$TAG
FOLDER="$PKG_NAME*"
if $(pkg-config --exists gdal); then
  INSTALLED_VERSION=$(pkg-config --modversion gdal)
fi

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  iecho "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL | tar xz && cd $FOLDER
  ./autogen.sh
  ./configure --prefix=$HOME/.local --with-libjson-c=$HOME/.local/include/json-c && \
    make -s -j$(nproc) && make -s install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

cd $ROOT
