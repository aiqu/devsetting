#!/usr/bin/env bash
#
#    FFmpeg installer
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

_R=$REINSTALL
unset REINSTALL
. $ROOT/install_scripts/nasm.sh
. $ROOT/install_scripts/yasm.sh
. $ROOT/install_scripts/freetype2.sh
REINSTALL=$_R
unset _R

PKG_NAME="ffmpeg"
REPO_URL="https://git.ffmpeg.org/ffmpeg.git"
TAG=$(git ls-remote https://git.ffmpeg.org/ffmpeg.git | awk -F/ '{print $3}' | grep -v -e '{}\|-\|v\|release\|oldabi' | sort -V | tail -n1)
VER=$(echo $TAG | sed 's/n//')
DOWN_URL="https://ffmpeg.org/releases/ffmpeg-${VER}.tar.xz"
FOLDER="$PKG_NAME*"
VERFILE=""
INSTALLED_VERSION=
if hash ffmpeg 2>/dev/null;then
  INSTALLED_VERSION=$(ffmpeg --version 2>&1 | head -n1 | cut -d' ' -f3)
fi

if ([ $LEVEL = 0 ] && [ ! -z $REINSTALL ]) || [ -z $INSTALLED_VERSION ] || $(compare_version $INSTALLED_VERSION $VER); then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  BUILDDIR=$WORKDIR/build
  BINDIR=${LOCAL_DIR}/bin

  curl -L $DOWN_URL | tar xJ
  cd $FOLDER

  ./configure \
    --prefix=${LOCAL_DIR} \
    --disable-htmlpages \
    --disable-podpages \
    --disable-txtpages \
    --pkg-config-flags="--static" \
    --extra-libs=-lpthread \
    --enable-gpl \
    --enable-libfreetype \
    --enable-nonfree
  make -s -j${NPROC}
  make -s install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

LEVEL=$(( ${LEVEL}-1 ))
cd $ROOT
rm -rf $WORKDIR
