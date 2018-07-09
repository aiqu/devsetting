#!/usr/bin/env bash
#
#    Flex installer
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

if [ $OS == 'mac' ]; then
  brew install flex
else
  . $ROOT/install_scripts/bison.sh
  . $ROOT/install_scripts/help2man.sh

  PKG_NAME="flex"
  REPO_URL="https://github.com/westes/flex"
  TAG=$(git ls-remote -t $REPO_URL | grep -v -e '{}\|flex' | cut -d/ -f3 | sort -V | tail -n1)
  VER=$(echo $TAG | sed 's/v//')
  FOLDER="$PKG_NAME*"
  INSTALLED_VERSION=
  if hash flex 2>/dev/null;then
    INSTALLED_VERSION=$(flex -V | cut -d' ' -f2)
  fi

  if ([ $LEVEL = 0 ] && [ ! -z $REINSTALL ]) || [ -z $INSTALLED_VERSION ] || $(compare_version $INSTALLED_VERSION $VER); then
    # install bootstraping flex if no installation exists
    if [ -z $INSTALLED_VERSION ]; then
      mkdir -p $TMP_DIR && cd $TMP_DIR
      BOOTSTRAP_TAG='v2.6.2'
      BOOTSTRAP_VER='2.6.2'
      iecho "$PKG_NAME $BOOTSTRAP_VER installation for bootstraping.."
      curl -L https://github.com/westes/flex/releases/download/$BOOTSTRAP_TAG/flex-${BOOTSTRAP_VER}.tar.gz | tar xz
      cd $FOLDER
      ./autogen.sh
      ./configure --prefix=${LOCAL_DIR}
      make -s -j${NPROC} && make -s install 1>/dev/null
      cd $ROOT && rm -rf $TMP_DIR
    fi

    iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

    mkdir -p $TMP_DIR && cd $TMP_DIR
    curl -LO $REPO_URL/archive/$TAG.zip
    unzip -q $TAG.zip && rm -rf $TAG.zip && cd $FOLDER
    ./autogen.sh
    ./configure --prefix=${LOCAL_DIR}
    make -s -j${NPROC} && make -s install 1>/dev/null

    cd $ROOT && rm -rf $TMP_DIR
  else
    gecho "$PKG_NAME $VER is already installed"
  fi

  cd $ROOT
fi
LEVEL=$(( ${LEVEL}-1 ))
