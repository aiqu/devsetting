#!/usr/bin/env bash
#
#    Cmake installer
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
. $ROOT/envset.sh
. $ROOT/install_scripts/zlib.sh
. $ROOT/install_scripts/curl.sh

PKG_NAME="cmake"
REPO_URL=https://github.com/Kitware/CMake
TAG=$(git ls-remote --tags $REPO_URL | awk -F/ '{print $3}' | grep -v -e '{}' -e 'rc' | sort -V | tail -n1)
VER=$(echo $TAG | sed 's/v//')
FOLDER="CMake-$VER"
INSTALLED_VER=$($PKG_NAME --version 2>/dev/null | grep version | awk '{print $3}')

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VER ] || [ $INSTALLED_VER != $VER ];then
  iecho "$PKG_NAME installation.. install location: $LOCAL_DIR"

  mkdir -p $TMP_DIR && cd $TMP_DIR

  iecho "Downloading CMake $VER"
  curl -LO ${REPO_URL}/archive/${TAG}.zip
  unzip -q ${TAG}.zip
  cd $FOLDER
  ./bootstrap --prefix=${LOCAL_DIR} --parallel=${NPROC} --no-system-libs --system-curl

  make -s -j${NPROC}
  make -s install 1>/dev/null

  cd $PWD && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

cd $ROOT
