#!/usr/bin/env bash
#
#    CUDA & Cudnn installer
#     - Refered nvidia cuda dockerfile
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

if [ ! $(whoami) == 'root' ];then
    eecho "run it with sudo"
    exit 1
fi

if [ $OS == "ubuntu" ] || [ $OS == "debian" ];then
  VERSION_ID=$(cat /etc/os-release | grep VERSION_ID | cut -d'"' -f2)
  if [ $VERSION_ID != "16.04" ];then
    eecho "This script only supports Ubuntu 16.04"
    exit 1
  fi
  apt update && \
    apt install -y --no-install-recommends ca-certificates apt-transport-https gnupg-curl && \
    NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
    NVIDIA_GPGKEY_FPR=ae09fe4bbd223a84b2ccfce3f60f4b3d7fa2af80 && \
    apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub && \
    apt-key adv --export --no-emit-version -a $NVIDIA_GPGKEY_FPR | tail -n +5 > cudasign.pub && \
    echo "$NVIDIA_GPGKEY_SUM  cudasign.pub" | sha256sum -c --strict - && rm cudasign.pub && \
    echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/cuda.list
    echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

  CUDA_VERSION=9.2.148
  CUDA_PKG_VERSION="9-2=${CUDA_VERSION}-1"
  NCCL_VERSION=2.3.5
  CUDNN_VERSION=7.2.1.38

  apt update && \
    apt install -y --no-install-recommends --allow-downgrades \
    cuda-cudart-$CUDA_PKG_VERSION \
    cuda-libraries-$CUDA_PKG_VERSION \
    cuda-nvtx-$CUDA_PKG_VERSION \
    libnccl2=$NCCL_VERSION-2+cuda9.2 \
    libcudnn7=$CUDNN_VERSION-1+cuda9.2 \

  if [ -z $RUNTIMEONLY ];then
    apt install -y --no-install-recommends \
      cuda-libraries-dev-$CUDA_PKG_VERSION \
      cuda-nvml-dev-$CUDA_PKG_VERSION \
      cuda-minimal-build-$CUDA_PKG_VERSION \
      cuda-command-line-tools-$CUDA_PKG_VERSION \
      libnccl-dev=$NCCL_VERSION-2+cuda9.2 \
      libcudnn7-dev=$CUDNN_VERSION-1+cuda9.2
  fi

  apt-mark hold libnccl2 libcudnn7
  rm -f /usr/local/cuda
  ln -s cuda-9.2 /usr/local/cuda
  if ! $(grep -q '/usr/local/nvidia/lib' /etc/ld.so.conf.d/nvidia.conf 2>/dev/null);then
    echo "/usr/local/nvidia/lib\n/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf
  fi
  if ! $(grep -q '/usr/local/cuda/lib64/stubs' /etc/ld.so.conf.d/cuda.conf 2>/dev/null);then
    echo "/usr/local/cuda/lib64/stubs" >> /etc/ld.so.conf.d/cuda.conf
  fi
  ldconfig

elif [ $OS == "centos" ];then
    NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
        curl --retry 10 -fsSL https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/7fa2af80.pub | sed '/^Version/d' > /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA && \
        echo "$NVIDIA_GPGKEY_SUM  /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA" | sha256sum -c --strict -

    printf "[cuda]\nname=cuda\nbaseurl=http://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64\nenabled=1\ngpgcheck=1\ngpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA" > /etc/yum.repos.d/cuda.repo

    CUDA_VERSION=9.2.148
    CUDA_PKG_VERSION=9-2-${CUDA_VERSION}-1

    yum install -y cuda-cudart-${CUDA_PKG_VERSION} \
      cuda-libraries-${CUDA_PKG_VERSION} \
      cuda-nvcc-${CUDA_PKG_VERSION}
    rm -f /usr/local/cuda
    ln -s cuda-9.2 /usr/local/cuda
    LIBSTRING="/usr/local/nvidia/lib\n/usr/local/nvidia/lib64\n/usr/local/cuda/lib\n/usr/local/cuda/lib64"
    LDCONFFILE='/etc/ld.so.conf.d/nvidia.conf'
    if ! $(grep -q $LIBSTRING $LDCONFFILE 2>/dev/null);then
      echo -e $LIBSTRING > $LDCONFFILE
    fi
    if [ -z $RUNTIMEONLY ];then
      yum install -y cuda-libraries-dev-${CUDA_PKG_VERSION} \
        cuda-nvml-dev-${CUDA_PKG_VERSION} \
        cuda-minimal-build-${CUDA_PKG_VERSION} \
        cuda-command-line-tools-${CUDA_PKG_VERSION}
    fi
    rm -rf /var/cache/yum/*

    CUDNN_DOWNLOAD_SUM=f875340f812b942408098e4c9807cb4f8bdaea0db7c48613acece10c7c827101 && \
      curl --retry 10 -fsSL http://developer.download.nvidia.com/compute/redist/cudnn/v7.1.4/cudnn-9.2-linux-x64-v7.1.tgz -O && \
      echo "$CUDNN_DOWNLOAD_SUM  cudnn-9.2-linux-x64-v7.1.tgz" | sha256sum -c - && \
      tar --no-same-owner -xzf cudnn-9.2-linux-x64-v7.1.tgz -C /usr/local && \
      rm cudnn-9.2-linux-x64-v7.1.tgz && \
      ldconfig

  # Install NCCL 2.2.13
  curl --retry 10 -L 'https://drive.google.com/uc?authuser=0&id=1cw4LWfuerNheqmVsxKngQvP4YWhu83il&export=download' -o nccl.txz \
    && mkdir -p nccl /usr/local/cuda/lib \
    && tar xf nccl.txz --strip-components=1 -C nccl \
    && cp -a nccl/include/* /usr/local/cuda/include/ \
    && cp -a nccl/lib/* /usr/local/cuda/lib/ \
    && cp -a nccl/NCCL-SLA.txt /usr/local/cuda/ \
    && rm -rf nccl.txz nccl && ldconfig
fi
