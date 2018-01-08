#!/bin/bash
#
#    Byobu installer
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

. $ROOT/install_scripts/tmux.sh

PKG_NAME="byobu"
REPO_URL=https://github.com/aiqu/byobu

if [ ! -z $REINSTALL ] || [ ! -x ${LOCAL_DIR}/bin/byobu ];then
  iecho "$PKG_NAME installation.. install location: $LOCAL_DIR"

  mkdir -p $HOME/.lib && cd $HOME/.lib
  if [ ! -d byobu ];then
    git clone --depth=1 $REPO_URL
  fi

  cd byobu && git pull
  ./autogen.sh
  ./configure --prefix="${LOCAL_DIR}"
  make -s -j$(nproc)
  make -s install 1>/dev/null
else
  gecho "$PKG_NAME is already installed"
fi

cd $ROOT
