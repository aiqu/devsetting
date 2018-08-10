#!/usr/bin/env bash
#
#    Erlang installer
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
. $ROOT/install_scripts/openssl.sh

PKG_NAME="Erlang"
REPO_URL="https://github.com/erlang/otp"
TAG=$(git ls-remote -t $REPO_URL | grep -v -e '{}\|R\|_' | cut -d/ -f3 | sort -V | tail -n1)
CUSTOMTAGNAME="${PKG_NAME}TAG"
TAG=${!CUSTOMTAGNAME:-$TAG}
VER=$(echo $TAG | cut -d'-' -f2)
FOLDER="otp-$TAG"
INSTALLED_VERSION=$(find ${LOCAL_DIR}/lib/erlang/releases -name OTP_VERSION | xargs cat | sort -V | tail -n1)

if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_VERSION ] || $(compare_version $INSTALLED_VERSION $VER); then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl --retry 10 -L $REPO_URL/archive/$TAG.tar.gz | tar xz && cd $FOLDER
  export ERL_TOP=$(pwd)
  ./otp_build autoconf
  ./configure --prefix=${LOCAL_DIR} --with-ssl=${LOCAL_DIR}/include/openssl --with-ssl-rpath=${LOCAL_DIR}/lib
  make -s -j${NPROC}
  make -s install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
  unset ERL_TOP
else
  gecho "$PKG_NAME $VER is already installed"
fi

. $ROOT/install_scripts/rebar3.sh

LEVEL=$(( ${LEVEL}-1 ))
cd $ROOT
