#!/usr/bin/env bash
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

if [ $OS == 'mac' ];then
  brew install curl
else
  . $ROOT/install_scripts/libssh2.sh

  PKG_NAME="curl"
  REPO_URL="https://github.com/curl/curl"
  if [ $OS == 'centos' ];then
    # use the centos7 repository version to avoid a conflict
    TAG='curl-7_29_0'
  else
    TAG=$(git ls-remote -t $REPO_URL | grep -v '{}\|pre' | grep curl | cut -d/ -f3 | sort -V | tail -n1)
  fi
  CUSTOMTAGNAME="$(echo ${PKG_NAME} | sed 's/-//')TAG"
  TAG=${!CUSTOMTAGNAME:-$TAG}
  VER=$(echo $TAG | sed 's/curl-//' | sed 's/_/./g')
  FOLDER="$PKG_NAME*"
  VERFILE=""
  INSTALLED_VERSION=
  PKG_CONFIG_PATH="/usr/lib/pkgconfig:$PKG_CONFIG_PATH"
  if PKG_CONFIG_PATH=$PKG_CONFIG_PATH pkg-config --exists libcurl;then
    INSTALLED_VERSION=$(PKG_CONFIG_PATH=$PKG_CONFIG_PATH pkg-config --modversion libcurl)
  fi

  if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_VERSION ]; then
    iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

    mkdir -p $TMP_DIR && cd $TMP_DIR
    curl -L $REPO_URL/archive/$TAG.tar.gz | tar xz
    cd $FOLDER
    ./buildconf
    ./configure --prefix=${LOCAL_DIR} \
      --disable-debug \
      --enable-optimize \
      --disable-curldebug \
      --enable-shared \
      --enable-static \
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
      --enable-ipv6 \
      --disable-versioned-symbols \
      --enable-sspi \
      --enable-crypto-auto \
      --enable-tls-srp \
      --enable-unix-sockets \
      --enable-cookies
    make -s -j${NPROC}
    make -s install 1>/dev/null

    cd $ROOT && rm -rf $TMP_DIR
  else
    gecho "$PKG_NAME $INSTALLED_VERSION is already installed"
  fi

  cd $ROOT
fi
LEVEL=$(( ${LEVEL}-1 ))
