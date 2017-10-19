#!/bin/bash

set -e

if [ ! $ROOT ];then
    if [ ! -d 'install_scripts' ];then
        ROOT=$(pwd)/..
    else
        ROOT=$(pwd)
    fi
fi

source $ROOT/envset.sh

PWD=$(pwd)
WORKDIR=$HOME/.lib
INSTALL_DIR=$HOME/.local

pip2 install numpy && pip3 install numpy

if [ $OS == 'centos' ];then
	$SUDO yum install -y libpng-devel libjpeg-turbo-devel jasper-devel openexr-devel libtiff-devel libwebp-devel libdc1394-devel libv4l-devel gstreamer-plugins-base-devel tbb-devel
elif [ $OS == 'ubuntu' ];then
	$SUDO apt install -y build-essential cmake git pkg-config libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libgtk2.0-dev libatlas-base-dev gfortran tesseract-ocr libtesseract-dev libleptonica-dev libatlas-dev libdc1394-22-dev
fi

cd $WORKDIR
REPO_URL=https://github.com/opencv/opencv
CONTRIB_REPO_URL=https://github.com/opencv/opencv_contrib
TAG=$(git ls-remote --tags $REPO_URL | awk -F/ '{print $3}' | grep -v -e '{}' -e '-' | sort -t '/' -k 3 -V | tail -n1)
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
#PYTHON2_LIBRARY=$HOME/.local/lib/python2.7/
PYTHON2_INCLUDE_DIR=$HOME/.local/include/python2.7
#PYTHON3_LIBRARY=$(pyenv prefix 3.6.1)/lib
PYTHON3_INCLUDE_DIR=$HOME/.local/include/python3.6m
if [ -f /usr/local/cuda/version.txt ]; then
  cmake -DCMAKE_BUILD_TYPE=RELEASE \
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
    ..
else
  cmake -DCMAKE_BUILD_TYPE=RELEASE \
    -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
    -DOPENCV_EXTRA_MODULES_PATH=$CONTRIB_MODULE_DIR \
    -DBUILD_opencv_python3=ON \
    -DBUILD_EXAMPLES=OFF \
    -DENABLE_FAST_MATH=1 \
    -DWITH_TBB=ON \
    -DPYTHON2_INCLUDE_DIR=$PYTHON2_INCLUDE_DIR \
    -DPYTHON3_INCLUDE_DIR=$PYTHON3_INCLUDE_DIR \
    ..
fi
make -j$(nproc) && make install
