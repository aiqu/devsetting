#!/usr/bin/env bash
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

FILENAME=`basename ${BASH_SOURCE[0]}`
FILENAME=${FILENAME%%.*}
DONENAME="DONE$FILENAME"
if [ ! -z ${!DONENAME+x} ];then
  return 0
fi
let DONE$FILENAME=1

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
. $ROOT/envset.sh

TF_SRC_DIR=${GOPATH}/src/tensorflow/tensorflow
TF_PKG_DIR=${HOME}/.lib/tensorflow_pkg

#install prerequisites
. $ROOT/install_scripts/python.sh
pip2 install numpy scipy
pip3 install numpy scipy
. $ROOT/install_scripts/jdk8.sh
. $ROOT/install_scripts/bazel.sh

#install tensorflow
go get -d github.com/tensorflow/tensorflow/tensorflow/go
cd ${GOPATH}/src/github.com/tensorflow/tensorflow
./configure
bazel build --config=opt --config=cuda //tensorflow/tools/pip_package:build_pip_package
bazel-bin/tensorflow/tools/pip_package/build_pip_package $TF_PKG_DIR
iecho "---------------------------------"
iecho "output file created at $TF_PKG_DIR"
