#!/usr/bin/env bash
#
#    <nccl> installer
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

PKG_NAME="nccl"
REPO_URL="http://github.com/NVIDIA/nccl"
TAG=$(git ls-remote -t $REPO_URL | grep -v {} | cut -d/ -f3 | sort -V | tail -n1)
CUSTOMTAGNAME="$(echo ${PKG_NAME} | sed 's/-//')TAG"
TAG=${!CUSTOMTAGNAME:-$TAG}
VER=$(echo $TAG | sed 's/v//' | cut -d'-' -f1)
FOLDER="$PKG_NAME*"
CUDAPATH='/usr/local/cuda'
VERFILE="$CUDAPATH/include/nccl.h"
VERMAJOR=$(echo $VER | cut -d'.' -f1)
VERMINOR=$(echo $VER | cut -d'.' -f2)
VERPATCH=$(echo $VER | cut -d'.' -f3)
VERCODE=$(($VERMAJOR*1000 + $VERMINOR*100 + $VERPATCH))
INSTALLED_VERSION=$(grep 'define NCCL_VERSION_CODE' $VERFILE | cut -d' ' -f3)

if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_VERSION ] || $(compare_version $INSTALLED_VERSION $VER); then
  iecho "$PKG_NAME $VER installation.. install location: $CUDAPATH"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl --retry 10 -L $REPO_URL/archive/$TAG.tar.gz | tar xz && cd $FOLDER
  make -s -j src.install PREFIX=$CUDAPATH 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG_NAME $VER is already installed"
fi

LEVEL=$(( ${LEVEL}-1 ))
cd $ROOT
