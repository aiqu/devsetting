#!/usr/bin/env bash
#
#    NodeJS installer
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

PKG_NAME="node"
REPO_URL="https://github.com/nodejs/node"
TAG=$(git ls-remote -t $REPO_URL | grep -v {} | cut -d/ -f3 | sort -V | tail -n1)
if [ $LEVEL -le 1 ];then
  TAG=${CUSTOMTAG:-$TAG}
fi
VER=$(echo $TAG | sed 's/v//')
FOLDER="$PKG_NAME*"
VERFILE=""
INSTALLED_VERSION=
if hash node 2>/dev/null;then
  INSTALLED_VERSION=$(node -v | sed 's/v//')
fi

REQUIRED_GCC_VERSION="4.9.4"
REQUIRED_MAKE_VERSION="3.81"
REQUIRED_PYTHON_VERSION="2.6"

if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_VERSION ] || $(compare_version $INSTALLED_VERSION $VER); then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

  GCC_VERSION=$(gcc --version | head -n1 | cut -d' ' -f3)
  GPP_VERSION=$(g++ --version | head -n1 | cut -d' ' -f3)
  MAKE_VERSION=$(make -v | head -n1 | cut -d' ' -f3)
  PYTHON_VERSION=$(python --version 2>&1 | cut -d' ' -f2)
  if compare_version $GCC_VERSION $REQUIRED_GCC_VERSION; then
    eecho "Require GCC $REQUIRED_GCC_VERSION, found $GCC_VERSION"
    exit 1
  fi
  if compare_version $GPP_VERSION $REQUIRED_GPP_VERSION; then
    eecho "Require G++ $REQUIRED_GPP_VERSION, found $GPP_VERSION"
    exit 1
  fi
  if compare_version $MAKE_VERSION $REQUIRED_MAKE_VERSION; then
    eecho "Require MAKE $REQUIRED_MAKE_VERSION, found $MAKE_VERSION"
    exit 1
  fi
  if compare_version $PYTHON_VERSION $REQUIRED_PYTHON_VERSION; then
    eecho "Require PYTHON $REQUIRED_PYTHON_VERSION, found $PYTHON_VERSION"
    exit 1
  fi

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -LO $REPO_URL/archive/$TAG.zip
  unzip -q $TAG.zip && rm -rf $TAG.zip && cd $FOLDER
  ./configure --prefix=${LOCAL_DIR}
  make -s -j${NPROC}
  make -s install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

LEVEL=$(( ${LEVEL}-1 ))
cd $ROOT
