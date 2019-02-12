#!/usr/bin/env bash
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

if [ -z $SKIPDEPS ];then
  . $ROOT/install_scripts/python.sh
  . $ROOT/install_scripts/protobuf.sh
  . $ROOT/install_scripts/tbb.sh
fi

PKG_NAME="opencv"
REPO_URL=https://github.com/opencv/opencv
CONTRIB_REPO_URL=https://github.com/opencv/opencv_contrib
TAG=$(git ls-remote --tags $REPO_URL | awk -F/ '{print $3}' | grep -v -e '{}' -e '-' | sort -V | tail -n1)
CUSTOMTAGNAME="${PKG_NAME}TAG"
TAG=${!CUSTOMTAGNAME:-$TAG}
VER=$TAG
CUDA_BIN_PATH="/usr/local/cuda-8.0"

if hash pip2 2>/dev/null;then
  pip2 install numpy
fi
if hash pip3 2>/dev/null;then
  pip3 install numpy
fi

INSTALLED_VERSION=
if $(hash opencv_version); then
  INSTALLED_VERSION=$(opencv_version)
fi
if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_VERSION ] || $(compare_version $INSTALLED_VERSION $TAG); then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"
  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl --retry 10 -L ${REPO_URL}/archive/${TAG}.tar.gz | tar xz
  curl --retry 10 -L ${CONTRIB_REPO_URL}/archive/${TAG}.tar.gz | tar xz
  cd opencv-${TAG} && mkdir -p build && cd build 
  CONTRIB_MODULE_DIR="$TMP_DIR/opencv_contrib-${TAG}/modules"
  PYTHON3_INCLUDE_DIR=${LOCAL_DIR}/include/python3.6m
  PYTHON3_LIBRARY=${LOCAL_DIR}/lib/libpython3.6m.so
  MY_CXX_FLAGS="-std=c++11"
  if [ ! -z $OPTIMIZE ];then
    MY_CXX_FLAGS="${MY_CXX_FLAGS} -O2 -march=native"
  fi
  # use own CUDA GENERATION name
  #MY_CUDA_GEN="Pascal"
  OPENCV_CMAKE_OPTIONS=(
    -DCMAKE_BUILD_TYPE=RELEASE
    -DCMAKE_INSTALL_PREFIX=$LOCAL_DIR
    -DOPENCV_EXTRA_MODULES_PATH=$CONTRIB_MODULE_DIR
    -DPYTHON_DEFAULT_EXECUTABLE=$(which python)
    -DBUILD_opencv_python2=OFF
    -DBUILD_opencv_python3=${OPENCV_PYTHON3:-'ON'}
    -DBUILD_opencv_datasets=OFF
    -DBUILD_opencv_dnn=OFF
    -DBUILD_opencv_dnn_objdetect=OFF
    -DBUILD_opencv_face=OFF
    -DBUILD_opencv_java_bindings_generator=OFF
    -DBUILD_opencv_python_bindings_generator=${OPENCV_PYTHON3:-'ON'}
    -DBUILD_opencv_video=ON
    -DBUILD_opencv_videoio=ON
    -DBUILD_opencv_videostab=OFF
    -DBUILD_opencv_apps=OFF
    -DBUILD_EXAMPLES=OFF
    -DBUILD_DOCS=OFF
    -DBUILD_PERF_TESTS=OFF
    -DBUILD_TESTS=OFF
    -DBUILD_JAVA=OFF
    -DENABLE_CCACHE=ON
    -DENABLE_FAST_MATH=1
    -DWITH_TBB=ON
    -DWITH_VTK=ON
    -DWITH_FFMPEG=ON
    -DWITH_GSTREAMER=OFF
    -DWITH_GTK=ON
    -DWITH_V4L=ON
    -DWITH_DSHOW=OFF
    -DWITH_MATLAB=OFF
    -DPYTHON3_INCLUDE_DIR=$PYTHON3_INCLUDE_DIR
    -DPYTHON3_LIBRARY=$PYTHON3_LIBRARY
    -DOPENCV_ENABLE_NONFREE=ON
    -DBUILD_JPEG=ON
    -DBUILD_PNG=ON
    -DBUILD_TIFF=ON
  )
  BUILDSTATIC="${PKG_NAME}STATIC"
  if [ ! -z ${!BUILDSTATIC} ];then
    OPENCV_CMAKE_OPTIONS+=(
      -DBUILD_SHARED_LIBS=OFF
    )
  fi
  if [ -f /usr/local/cuda/version.txt ]; then
    cmake ${OPENCV_CMAKE_OPTIONS[@]} \
      -DWITH_CUDA=ON \
      -DCMAKE_CXX_FLAGS="${MY_CXX_FLAGS}" \
      -DCUDA_NVCC_FLAGS="-std=c++11 --expt-relaxed-constexpr" \
      -DCUDA_PROPAGATE_HOST_FLAGS=OFF \
      -DCUDA_FAST_MATH=1 \
      -DWITH_CUBLAS=1 \
      -DCUDA_GENERATION=${MY_CUDA_GEN:="Auto"} \
      ..
  else
    cmake ${OPENCV_CMAKE_OPTIONS[@]} -DCMAKE_CXX_FLAGS="${MY_CXX_FLAGS}" ..
  fi
  make -s -j${NPROC}
  make -s install 1>/dev/null
  if [ ${OPENCV_PYTHON3} == 'ON' ];then
    cp lib/python3/cv2.*.so $(python -c 'import site; print(site.getsitepackages()[0])')
  fi

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "OpenCV $VER is already installed"
fi

LEVEL=$(( ${LEVEL}-1 ))
