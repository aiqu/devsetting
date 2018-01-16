#!/bin/bash
#
#    OpenCV installer
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
. $ROOT/install_scripts/python.sh
. $ROOT/install_scripts/protobuf.sh

PKG_NAME="opencv"
REPO_URL=https://github.com/opencv/opencv
CONTRIB_REPO_URL=https://github.com/opencv/opencv_contrib
TAG=$(git ls-remote --tags $REPO_URL | awk -F/ '{print $3}' | grep -v -e '{}' -e '-' | sort -V | tail -n1)
VER=$TAG
CUDA_BIN_PATH="/usr/local/cuda-8.0"
WORKDIR=$HOME/.lib
INSTALL_DIR=${LOCAL_DIR}

pip2 install numpy && pip3 install numpy

#TODO
# remove package manager dependency
if [ $OS == 'centos' ];then
  $SUDO yum install -y libjpeg-turbo-devel jasper-devel openexr-devel libtiff-devel libwebp-devel libdc1394-devel libv4l-devel gstreamer-plugins-base-devel tbb-devel
elif [ $OS == 'ubuntu' ];then
  $SUDO apt install -y libjpeg8-dev libtiff5-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libgtk2.0-dev gfortran tesseract-ocr libtesseract-dev libleptonica-dev libatlas-dev libdc1394-22-dev
fi

if $(which opencv_version); then
  INSTALLED_VERSION=$(opencv_version)
fi
if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $TAG != $INSTALLED_VERSION ]; then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"
  cd $WORKDIR
  if [ ! -d opencv-${TAG} ];then
    curl -LO ${REPO_URL}/archive/${TAG}.zip
    unzip -q ${TAG}.zip && rm ${TAG}.zip
  fi
  if [ ! -d opencv_contrib-${TAG} ];then
    curl -LO ${CONTRIB_REPO_URL}/archive/${TAG}.zip
    unzip -q ${TAG}.zip && rm ${TAG}.zip
  fi
  cd opencv-${TAG} && mkdir -p build && cd build 
  CONTRIB_MODULE_DIR="$WORKDIR/opencv_contrib-${TAG}/modules"
  PYTHON2_INCLUDE_DIR=${LOCAL_DIR}/include/python2.7
  PYTHON3_INCLUDE_DIR=${LOCAL_DIR}/include/python3.6m
  PYTHON2_LIBRARY=${LOCAL_DIR}/lib/libpython2.7.so
  PYTHON3_LIBRARY=${LOCAL_DIR}/lib/libpython3.6m.so
  # uncomment if install it locally
  #MY_CXX_FLAGS="-O2 -march=native -pipe"
  if [ -f /usr/local/cuda/version.txt ]; then
    cmake -DCMAKE_BUILD_TYPE=RELEASE \
      -DCMAKE_CXX_FLAGS="-std=c++11 $MY_CXX_FLAGS" \
      -DCUDA_NVCC_FLAGS="-std=c++11 --expt-relaxed-constexpr" \
      -DCUDA_PROPAGATE_HOST_FLAGS=OFF \
      -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
      -DOPENCV_EXTRA_MODULES_PATH=$CONTRIB_MODULE_DIR \
      -DBUILD_opencv_python3=ON \
      -DBUILD_EXAMPLES=OFF \
      -DCUDA_FAST_MATH=1 \
       -DWITH_CUBLAS=1 \
      -DENABLE_FAST_MATH=1 \
      -DWITH_TBB=ON \
      -DPYTHON2_INCLUDE_DIR=$PYTHON2_INCLUDE_DIR \
      -DPYTHON3_INCLUDE_DIR=$PYTHON3_INCLUDE_DIR \
      -DPYTHON2_LIBRARY=$PYTHON2_LIBRARY \
      -DPYTHON3_LIBRARY=$PYTHON3_LIBRARY \
      ..
  else
    cmake -DCMAKE_BUILD_TYPE=RELEASE \
      -DCMAKE_CXX_FLAGS="-std=c++11 $MY_CXX_FLAGS" \
      -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
      -DOPENCV_EXTRA_MODULES_PATH=$CONTRIB_MODULE_DIR \
      -DBUILD_opencv_python3=ON \
      -DBUILD_EXAMPLES=OFF \
      -DENABLE_FAST_MATH=1 \
      -DWITH_TBB=ON \
      -DPYTHON2_INCLUDE_DIR=$PYTHON2_INCLUDE_DIR \
      -DPYTHON3_INCLUDE_DIR=$PYTHON3_INCLUDE_DIR \
      -DPYTHON2_LIBRARY=$PYTHON2_LIBRARY \
      -DPYTHON3_LIBRARY=$PYTHON3_LIBRARY \
      ..
  fi
  make -s -j$(nproc)
  make -s install 1>/dev/null
else
  gecho "OpenCV $VER is already installed"
fi
