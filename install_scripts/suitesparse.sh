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

if [ -z $SKIPDEPS ];then
  . $ROOT/install_scripts/lapack.sh
fi

PKG_NAME="SuiteSparse"
PWD=$(pwd)

iecho "$PKG_NAME installation.."
mkdir -p $TMP_DIR && cd $TMP_DIR
VER='5.4.0'
SRCFILE="SuiteSparse-$VER.tar.gz"
if [ ! -d SuiteSparse ]; then
  curl --retry 10 -L http://faculty.cse.tamu.edu/davis/SuiteSparse/$SRCFILE | tar xzf -
fi
cd SuiteSparse
make -s BLAS=-lblas JOBS=${NPROC} library
make -s BLAS=-lblas JOBS=${NPROC} INSTALL=${LOCAL_DIR} library 1>/dev/null
# install static libraries also
find . -name '*\.a' | xargs -I{} cp {} ${LOCAL_DIR}/lib
cd $ROOT && rm -rf $TMP_DIR
LEVEL=$(( ${LEVEL}-1 ))
