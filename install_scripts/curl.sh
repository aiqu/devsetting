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

if pkg-config libcurl --exists;then
  INSTALLED_VERSION=$(pkg-config libcurl --modversion)
  gecho "libcurl $INSTALLED_VERSION already installed"
else
  if [ $OS == 'mac' ];then
    brew install curl
  elif [ $OS == 'ubuntu' ];then
    ${SUDO} apt install -y libcurl4-openssl-dev
  else
    ${SUDO} yum install -y curl-devel
  fi
fi
LEVEL=$(( ${LEVEL}-1 ))
