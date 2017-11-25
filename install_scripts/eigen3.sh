#!/bin/bash
#
#    Eigen3 installer
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
VER='3.3'

if [ $OS == 'centos' ]; then
  $SUDO yum install -y hg
elif [ $OS == 'ubuntu' ]; then
  $SUDO apt install -y mercurial
fi

cd $WORKDIR
if [ ! -d eigen ]; then
  hg clone https://bitbucket.org/eigen/eigen/
fi
cd eigen && hg up $VER &&  mkdir -p build && cd build && \
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local .. && \
make install
