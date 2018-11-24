#!/usr/bin/env bash
#
#    <clang> installer
#
#    Copyright (C) 2018 Gwangmin Lee
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

PKG_NAME="clang"
TAG='7.0.0'
CUSTOMTAGNAME="$(echo ${PKG_NAME} | sed 's/-//')TAG"
TAG=${!CUSTOMTAGNAME:-$TAG}
VER=$TAG
INSTALLED_VERSION=$(hash -r; clang --version | head -n1 | cut -d' ' -f3)

if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_VERSION ] || $(compare_version $INSTALLED_VERSION $VER); then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

  REPO_URL="http://releases.llvm.org/$TAG"
  UNPACK_CMD='tar xJ --strip-components=1 -C'

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $REPO_URL/$TAG/llvm-$TAG.src.tar.xz | tar xJ
  cd llvm*
  cd tools
  mkdir -p clang clang/tools/extra lld polly
  curl -L $REPO_URL/cfe-$TAG.src.tar.xz | $UNPACK_CMD clang
  curl -L $REPO_URL/clang-tools-extra-$TAG.src.tar.xz | $UNPACK_CMD clang/tools/extra
  curl -L $REPO_URL/lld-$TAG.src.tar.xz | $UNPACK_CMD lld
  curl -L $REPO_URL/polly-$TAG.src.tar.xz | $UNPACK_CMD polly
  cd ../projects
  mkdir -p compiler-rt openmp libcxx libcxxabi
  curl -L $REPO_URL/compiler-rt-$TAG.src.tar.xz | $UNPACK_CMD compiler-rt
  curl -L $REPO_URL/openmp-$TAG.src.tar.xz | $UNPACK_CMD openmp
  curl -L $REPO_URL/libcxx-$TAG.src.tar.xz | $UNPACK_CMD libcxx
  curl -L $REPO_URL/libcxxabi-$TAG.src.tar.xz | $UNPACK_CMD libcxxabi
  cd ..

  mkdir -p build && cd build
  cmake -DCMAKE_INSTALL_PREFIX=${LOCAL_DIR} -DCMAKE_BUILD_TYPE=Release ..
  make -s -j${NPROC}
  make -s install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

LEVEL=$(( ${LEVEL}-1 ))
cd $ROOT
