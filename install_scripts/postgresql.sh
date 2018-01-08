#!/bin/bash
#
#    postgresql installer
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

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="postgresql"
TMP_DIR=$ROOT/tmp
REPO_URL=https://ftp.postgresql.org/pub/source/v10.0/postgresql-10.0.tar.bz2
BIN=${LOCAL_DIR}/bin/postgres
FOLDER="$PKG_NAME*"
if [ -z $REINSTALL ] && [ ! -f $BIN ];then
  iecho "$PKG_NAME installation.."

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL | tar xj
  cd $FOLDER
  ./configure --prefix=${LOCAL_DIR}
  make -s -j$(nproc)
  make -s install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  INSTALLED_VERSION=$($BIN -V | cut -d' ' -f3)
  gecho "$PKG_NAME $INSTALLED_VERSION is already installed"
fi

cd $ROOT
