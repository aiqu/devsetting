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

TMP_DIR=$ROOT/tmp
REPO_URL=https://ftp.postgresql.org/pub/source/v10.0/postgresql-10.0.tar.bz2
BIN=$HOME/.local/bin/postgres
if [ -z $REINSTALL ] && [ -f $BIN ];then
  INSTALLED_VERSION=$($BIN -V | cut -d' ' -f3)
  echo "Postgresql $INSTALLED_VERSION is already installed"
else
  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL | tar xj && cd postgresql*
  ./configure --prefix=$HOME/.local && \
    make -s -j$(nproc) && make -s install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
fi

cd $ROOT
