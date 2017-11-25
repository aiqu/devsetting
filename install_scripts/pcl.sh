#!/bin/bash
#
#    PCL installer
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

source $ROOT/envset.sh

PWD=$(pwd)
WORKDIR=$HOME/.lib

cd $WORKDIR
REPO_URL=https://github.com/PointCloudLibrary/pcl
TAG=$(git ls-remote --tags $REPO_URL | awk -F/ '{print $3}' | grep -v -e '{}' -e 'rc' -e 'ros' | sort -V | tail -n1)
if [ ! -d pcl-${TAG} ];then
  echo "Downloading pcl $TAG"
  curl -LO ${REPO_URL}/archive/${TAG}.zip
  unzip -q ${TAG}.zip && rm ${TAG}.zip
fi
cd pcl-${TAG} && mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME/.local ..
make -j$(nproc) && make install
