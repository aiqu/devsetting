#!/usr/bin/env bash
#
#    OpenSSL installer
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

. $ROOT/install_scripts/zlib.sh

PKG_NAME="openssl"
SRC_DIR=$HOME/.lib/openssl
REPO_URL="https://github.com/openssl/openssl"
TAG=$(git ls-remote -t $REPO_URL | grep -v -e '{}\|pre\|FIPS' | grep OpenSSL | cut -d/ -f3 | sort -V | tail -n1)
CUSTOMTAGNAME="${PKG_NAME}TAG"
TAG=${!CUSTOMTAGNAME:-$TAG}
VER=$(echo $TAG | sed 's/OpenSSL.//' | sed 's/_/./g')
FOLDER="$PKG_NAME*"
VERFILE=""
INSTALLED_VERSION=
if pkg-config --exists openssl 2>/dev/null;then
  INSTALLED_VERSION=$(pkg-config --modversion openssl)
fi

if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_VERSION ]; then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL/archive/$TAG.tar.gz | tar xz
  cd $FOLDER
  ./config --prefix=${LOCAL_DIR} --openssldir=${LOCAL_DIR}/ssl threads shared enable-ssl3-method enable-ssl3 zlib -Wl,-rpath,'$(LIBRPATH)'
  make -s -j${NPROC}
  make -s -j${NPROC} install 1>/dev/null
  rm -rf ${LOCAL_DIR}/share/doc/openssl
  cp -r /etc/ssl/certs/* ${LOCAL_DIR}/ssl/certs/
  if [ $OS == 'centos' ];then
    ln -s /etc/pki/tls/cert.pem ${LOCAL_DIR}/ssl/cert.pem
  fi

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

LEVEL=$(( ${LEVEL}-1 ))
cd $ROOT
