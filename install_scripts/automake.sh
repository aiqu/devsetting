#!/usr/bin/env bash
#
#    Automake installer
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
  brew install automake
else
  PKG_NAME="automake"
  REPO_URL=" https://git.savannah.gnu.org/git/automake"
  DOWN_URL="http://ftp.kaist.ac.kr/gnu/automake/automake-"
  TAG=$(git ls-remote -t $REPO_URL | grep -v -e '{}\|branch' | cut -d/ -f3 | sort -V | tail -n1)
  CUSTOMTAGNAME="${PKG_NAME}TAG"
  TAG=${!CUSTOMTAGNAME:-$TAG}
  VER=$(echo $TAG | sed 's/v//')
  FOLDER="$PKG_NAME*"
  VERFILE=""
  INSTALLED_VERSION=
  if hash automake 2>/dev/null;then
    INSTALLED_VERSION=$(automake --version | head -n1 | cut -d' ' -f4)
  fi
  REQUIRED_VERSION='1.15.1'

  if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_VERSION ] || $(compare_version $INSTALLED_VERSION $REQUIRED_VERSION); then
    iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

    mkdir -p $TMP_DIR && cd $TMP_DIR
    curl --retry 10 -L $DOWN_URL$VER.tar.xz | tar xJ
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
