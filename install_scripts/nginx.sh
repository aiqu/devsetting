#!/bin/bash
#
#    nginx installer
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

. $ROOT/install_scripts/pcre.sh
. $ROOT/install_scripts/zlib.sh
. $ROOT/install_scripts/openssl.sh

PKG_NAME="nginx"
TMP_DIR=$ROOT/tmp
REPO_URL="https://github.com/nginx/nginx"
TAG=$(git ls-remote -t $REPO_URL | grep -v {} | cut -d/ -f3 | sort -V | tail -n1)
VER=$(echo $TAG | cut -d'-' -f2)
FOLDER="$PKG_NAME*"
VERFILE=""
INSTALLED_VERSION=$(nginx -v 2>&1 | cut -d/ -f2)

if [ ! -z $REINSTALL ] || [ -z "$INSTALLED_VERSION" ] || [ $VER != "$INSTALLED_VERSION" ]; then
  iecho "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -LO $REPO_URL/archive/$TAG.zip
  unzip -q $TAG.zip && rm -rf $TAG.zip && cd $FOLDER
  auto/configure --prefix=${LOCAL_DIR}/nginx \
    --with-threads \
    --sbin-path=${LOCAL_DIR}/bin/nginx \
    --with-http_ssl_module \
    --with-pcre \
    --with-openssl=$HOME/.lib/openssl
  make -s -j$(nproc)
  make -s install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

cd $ROOT
