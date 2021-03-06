#!/usr/bin/env bash
#
#    libuuid installer
#
#    Copyright (C) 2019 Gwangmin Lee
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

if [ -z $SKIPDEPS ]; then
  :
fi

PKG_NAME="libuuid"
REPO_URL="https://git.code.sf.net/p/libuuid/code"
TAG=$(git ls-remote -t $REPO_URL | grep -v {} | cut -d/ -f3 | sort -V | tail -n1)
CUSTOMTAGNAME="$(echo ${PKG_NAME} | sed 's/-//')TAG"
TAG=${!CUSTOMTAGNAME:-$TAG}
VER=$(echo $TAG | sed 's/libuuid-//')
FOLDER="$PKG_NAME*"
VERFILE=""
INSTALLED_VERSION=
if $(pkg-config --exists uuid);then
  INSTALLED_VERSION=$(pkg-config --modversion uuid)
fi

if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_VERSION ] || $(compare_version $INSTALLED_VERSION $VER); then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl --retry 10 -L https://sourceforge.net/projects/libuuid/files/$TAG.tar.gz/download | tar xz && cd $FOLDER
  BUILDSTATIC="$(echo ${PKG_NAME} | sed 's/-//')STATIC"
  CONFIG_OPTIONS="--prefix=${LOCAL_DIR}"
  if [ ! -z ${!BUILDSTATIC} ];then
    CONFIG_OPTIONS="$CONFIG_OPTIONS --enable-shared=no"
  fi
  ./configure $CONFIG_OPTIONS
  make -s -j${NPROC}
  make -s install 1>/dev/null
  ln -s $LOCAL_DIR/include/uuid/uuid.h $LOCAL_DIR/include/uuid.h

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

LEVEL=$(( ${LEVEL}-1 ))
cd $ROOT
