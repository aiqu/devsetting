#!/bin/bash

set -e

if [ ! $ROOT ];then
    if [ ! -d 'configurations' ];then
        ROOT=$(pwd)/..
    else
        ROOT=$(pwd)
    fi
fi

. $ROOT/envset.sh

if [ $OS == "ubuntu" ];then
    NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
        NVIDIA_GPGKEY_FPR=ae09fe4bbd223a84b2ccfce3f60f4b3d7fa2af80 && \
        apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub && \
        apt-key adv --export --no-emit-version -a $NVIDIA_GPGKEY_FPR | tail -n +5 > cudasign.pub && \
        echo "$NVIDIA_GPGKEY_SUM  cudasign.pub" | sha256sum -c --strict - && rm cudasign.pub && \
        echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/cuda.list
    echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

    export CUDA_VERSION=8.0.61
    export CUDA_PKG_VERSION=8-0=$CUDA_VERSION-1
    export CUDNN_VERSION=7.0.1.13

    apt update
    apt-get install -y --no-install-recommends \
            cuda-core-$CUDA_PKG_VERSION \
            cuda-nvrtc-$CUDA_PKG_VERSION \
            cuda-nvgraph-$CUDA_PKG_VERSION \
            cuda-cusolver-$CUDA_PKG_VERSION \
            cuda-cublas-8-0=8.0.61.2-1 \
            cuda-cufft-$CUDA_PKG_VERSION \
            cuda-curand-$CUDA_PKG_VERSION \
            cuda-cusparse-$CUDA_PKG_VERSION \
            cuda-npp-$CUDA_PKG_VERSION \
            cuda-cudart-$CUDA_PKG_VERSION \
            cuda-misc-headers-$CUDA_PKG_VERSION \
            cuda-command-line-tools-$CUDA_PKG_VERSION \
            cuda-nvrtc-dev-$CUDA_PKG_VERSION \
            cuda-nvml-dev-$CUDA_PKG_VERSION \
            cuda-nvgraph-dev-$CUDA_PKG_VERSION \
            cuda-cusolver-dev-$CUDA_PKG_VERSION \
            cuda-cublas-dev-8-0=8.0.61.2-1 \
            cuda-cufft-dev-$CUDA_PKG_VERSION \
            cuda-curand-dev-$CUDA_PKG_VERSION \
            cuda-cusparse-dev-$CUDA_PKG_VERSION \
            cuda-npp-dev-$CUDA_PKG_VERSION \
            cuda-cudart-dev-$CUDA_PKG_VERSION \
            cuda-driver-dev-$CUDA_PKG_VERSION \
            libcudnn7=$CUDNN_VERSION-1+cuda8.0 \
            libcudnn7-dev=$CUDNN_VERSION-1+cuda8.0 && \
            ${SUDO} ln -s cuda-8.0 /usr/local/cuda

    echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/cuda.conf && ldconfig

elif [ $OS == "cent" ];then
    NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
        curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/7fa2af80.pub | sed '/^Version/d' > /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA && \
        echo "$NVIDIA_GPGKEY_SUM  /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA" | sha256sum -c --strict -

    printf "[cuda]\nname=cuda\nbaseurl=http://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64\nenabled=1\ngpgcheck=1\ngpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA" > /etc/yum.repos.d/cuda.repo

    export CUDA_VERSION=8.0.61
    export CUDA_PKG_VERSION=8-0-$CUDA_VERSION-1
    export CUDNN_VERSION=7.0.1.13

    yum install -y \
            cuda-nvrtc-$CUDA_PKG_VERSION \
            cuda-nvgraph-$CUDA_PKG_VERSION \
            cuda-cusolver-$CUDA_PKG_VERSION \
            cuda-cublas-8-0-8.0.61.2-1 \
            cuda-cufft-$CUDA_PKG_VERSION \
            cuda-curand-$CUDA_PKG_VERSION \
            cuda-cusparse-$CUDA_PKG_VERSION \
            cuda-npp-$CUDA_PKG_VERSION \
            cuda-cudart-$CUDA_PKG_VERSION \
            cuda-core-$CUDA_PKG_VERSION \
            cuda-misc-headers-$CUDA_PKG_VERSION \
            cuda-command-line-tools-$CUDA_PKG_VERSION \
            cuda-license-$CUDA_PKG_VERSION \
            cuda-nvrtc-dev-$CUDA_PKG_VERSION \
            cuda-nvml-dev-$CUDA_PKG_VERSION \
            cuda-nvgraph-dev-$CUDA_PKG_VERSION \
            cuda-cusolver-dev-$CUDA_PKG_VERSION \
            cuda-cublas-dev-8-0-8.0.61.2-1 \
            cuda-cufft-dev-$CUDA_PKG_VERSION \
            cuda-curand-dev-$CUDA_PKG_VERSION \
            cuda-cusparse-dev-$CUDA_PKG_VERSION \
            cuda-npp-dev-$CUDA_PKG_VERSION \
            cuda-cudart-dev-$CUDA_PKG_VERSION \
            cuda-driver-dev-$CUDA_PKG_VERSION && \
            ln -s cuda-8.0 /usr/local/cuda && \
            echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/cuda.conf && ldconfig
        
    CUDNN_DOWNLOAD_SUM=288d844ab289b56d0c7b6719a34c7c0b57a01c58ffbe4d582c9b539da96ed2a7 && \
        curl -fsSL http://developer.download.nvidia.com/compute/redist/cudnn/v7.0.1/cudnn-8.0-linux-x64-v7.tgz -O && \
        echo "$CUDNN_DOWNLOAD_SUM  cudnn-8.0-linux-x64-v7.tgz" | sha256sum -c - && \
        tar --no-same-owner -xzf cudnn-8.0-linux-x64-v7.tgz -C /usr/local && \
        rm cudnn-8.0-linux-x64-v7.tgz && \
        ldconfig

    curl -LO https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-repo-rhel7-8.0.61-1.x86_64.rpm
    ${SUDO} rpm -i cuda-repo-rhel7-8.0.61-1.x86_64.rpm
    ${SUDO} yum install cuda
fi
