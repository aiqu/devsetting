#!/usr/bin/env bash
#
#    Autoconf installer
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

if [ $OS = "mac" ];then
  brew install autoconf
else
  PKG_NAME="autoconf"
  TAG='2.69'
  CUSTOMTAGNAME="${PKG_NAME}TAG"
  TAG=${!CUSTOMTAGNAME:-$TAG}
  REPO_URL="http://ftp.kaist.ac.kr/gnu/autoconf/autoconf-$TAG.tar.gz"
  VER=$TAG
  FOLDER="$PKG_NAME*"
  INSTALLED_VERSION=
  if hash autoconf 2>/dev/null;then
    INSTALLED_VERSION=$(autoconf --version | head -n1 | cut -d' ' -f4)
  fi

  if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_VERSION ] || $(compare_version $INSTALLED_VERSION $VER); then
    iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

    mkdir -p $TMP_DIR && cd $TMP_DIR
    curl --retry 10 -L $REPO_URL | tar xz
    cd $FOLDER
    ./configure --prefix=${LOCAL_DIR}
    make -s -j${NPROC}
    make -s install 1>/dev/null

    cd $ROOT && rm -rf $TMP_DIR
  else
    gecho "$PKG_NAME $VER is already installed"
  fi

  cd $ROOT
fi
LEVEL=$(( ${LEVEL}-1 ))
