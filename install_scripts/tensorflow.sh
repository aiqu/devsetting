#!/bin/bash
#
#    TensorFlow installer
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

FILENAME=`basename $0`
FILENAME=${FILENAME%%.*}
DONENAME="DONE$FILENAME"
if [ ! -z ${!DONENAME+x} ];then
  return 0
fi
let DONE$FILENAME=1

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
. $ROOT/envset.sh

SRC_DIR=$HOME/.lib
TF_SRC_DIR=${SRC_DIR}/tensorflow
TF_PKG_DIR=${TF_SRC_DIR}/tensorflow_pkg

#install prerequisites
. $ROOT/install_scripts/python.sh
pip2 install numpy scipy
pip3 install numpy scipy
. $ROOT/install_scripts/jdk8.sh
. $ROOT/install_scripts/bazel.sh

#install tensorflow
REPO_URL='https://github.com/tensorflow/tensorflow'
LATEST_TAG=$(git ls-remote -t $REPO_URL | grep -v -e'rc\|alpha' | cut -d'/' -f3 | sort -V | tail -n1)
cd $SRC_DIR
if [ -d $TF_SRC_DIR ];then
    cd $TF_SRC_DIR
    git fetch
    git checkout $LATEST_TAG
else
    git clone https://github.com/tensorflow/tensorflow -b $LATEST_TAG
fi
cd $TF_SRC_DIR
./configure
bazel build -c opt --copt=-mavx --copt=-mavx2 --copt=-mfma --copt=-msse4.2 --copt=-mfpmath=both --config=cuda -k //tensorflow/tools/pip_package:build_pip_package
bazel-bin/tensorflow/tools/pip_package/build_pip_package $TF_PKG_DIR
iecho "---------------------------------"
iecho "output file created at $TF_PKG_DIR"
