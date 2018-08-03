#!/usr/bin/env bash
#
#    JDK8 installer
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
. $ROOT/envset.sh

PKG_NAME="jdk"
VER="8u181"
WORKDIR=${LOCAL_DIR}

if ! java -version 2>&1 | grep -q '1.8' || ! javac -version 2>&1 | grep -q '1.8' || ! hash jar 2>/dev/null ;then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"
  mkdir -p $WORKDIR && cd $WORKDIR

  FILENAME='jdk-8u181-linux-x64.tar.gz'
  FOLDERNAME='jdk1.8.0_181'

  curl -jkL \
    -H "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
    "http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/$FILENAME" \
    | tar xz
  mkdir -p ${LOCAL_DIR}/bin
  ln -s ${LOCAL_DIR}/$FOLDERNAME/bin/* ${LOCAL_DIR}/bin/
else
  gecho "$PKG_NAME $VER is already installed"
fi

LEVEL=$(( ${LEVEL}-1 ))
