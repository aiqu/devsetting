#!/usr/bin/env bash
#
#    SuiteSparse installer
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

PKG_NAME="SuiteSparse"
PWD=$(pwd)
WORKDIR=$HOME/.lib

iecho "$PKG_NAME installation.."
mkdir -p $WORKDIR && cd $WORKDIR
VER='4.5.6'
SRCFILE="SuiteSparse-$VER.tar.gz"
if [ ! -d SuiteSparse ]; then
  curl -L http://faculty.cse.tamu.edu/davis/SuiteSparse/$SRCFILE | tar xzf -
fi
cd SuiteSparse
make -s metis  # At this step, "No rule to make target 'w'" would happen. It is safe to ignore it.
make -s BLAS=-lblas library -j
make -s install INSTALL=${LOCAL_DIR} BLAS=-lblas 1>/dev/null
cd $ROOT
