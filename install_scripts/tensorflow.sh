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

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

source $ROOT/envset.sh

SRC_DIR=$HOME
BAZEL_DIR=${SRC_DIR}/bazel
TF_SRC_DIR=${SRC_DIR}/tensorflow
TF_PKG_DIR=${TF_SRC_DIR}/tensorflow_pkg

#install prerequisites
pip2 install numpy scipy
pip3 install numpy scipy
. $ROOT/install_scripts/jdk8.sh
. $ROOT/install_scripts/bazel.sh

#install tensorflow
cd $SRC_DIR
if [ -d $TF_SRC_DIR ];then
    cd $TF_SRC_DIR
    git fetch
    git checkout v1.3.0-rc1
else
    git clone https://github.com/tensorflow/tensorflow -b v1.3.0-rc1
fi
cd $TF_SRC_DIR
#if you are using pyenv, make sure disable pyenv environment configuration
#otherwise, it will cause error because of the shim wrapper
./configure
bazel build -c opt --copt=-mavx --copt=-mavx2 --copt=-mfma --copt=-msse4.2 --copt=-mfpmath=both --config=cuda -k //tensorflow/tools/pip_package:build_pip_package
bazel-bin/tensorflow/tools/pip_package/build_pip_package $TF_PKG_DIR
echo "---------------------------------"
echo "output file created at $TF_PKG_DIR"
#test with python;import tensorflow as tf
