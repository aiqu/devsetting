#!/bin/bash
#
#    Curl installer
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

PKG_NAME="curl"
TMP_DIR=/tmp/devsetting
REPO_URL="https://github.com/curl/curl"
TAG=$(git ls-remote -t $REPO_URL | grep -v '{}\|pre' | grep curl | cut -d/ -f3 | sort -V | tail -n1)
VER=$(echo $TAG | sed 's/curl-//' | sed 's/_/./g')
FOLDER="$PKG_NAME*"
VERFILE=""
INSTALLED_VERSION=$(curl --version | head -n1 | cut -d' ' -f2 | sed 's/-DEV//')

if [ ! -z $REINSTALL ] || [ ! -f ${LOCAL_DIR}/bin/curl ]; then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -LO $REPO_URL/archive/$TAG.zip
  ${LOCAL_DIR}/bin/unzip -q $TAG.zip && rm -rf $TAG.zip && cd $FOLDER
  ./buildconf
  ./configure --prefix=${LOCAL_DIR} \
    --disable-debug \
    --enable-optimize \
    --disable-curldebug \
    --enable-http \
    --enable-ftp \
    --enable-file \
    --enable-ldap \
    --enable-ldaps \
    --enable-rtsp \
    --enable-proxy \
    --enable-dict \
    --enable-telnet \
    --enable-tftp \
    --enable-pop3 \
    --enable-imap \
    --enable-smb \
    --enable-smtp \
    --enable-gopher \
    --enable-manual \
    --enable-libcurl-option \
    --enable-libgcc \
    --enable-ipv6 \
    --enable-threaded-resolver \
    --enable-sspi \
    --enable-crypto-auto \
    --enable-tls-srp \
    --enable-unix-sockets \
    --enable-shared \
    --enable-cookies
  make -s -j$(nproc)
  make -s install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

cd $ROOT
