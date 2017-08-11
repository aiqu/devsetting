#!/bin/bash

set -e 

if [ ! $ROOT ];then
    if [ ! -d 'configurations' ];then
        ROOT=$(pwd)/..
    else
        ROOT=$(pwd)
    fi
fi

source $ROOT/envset.sh

#install prerequisites
$SUDO yum install epel-release
$SUDO yum update
$SUDO yum groupinstall 'Development Tools'
$SUDO yum install which wget git unzip zip python-devel.x86_64 python-pip python-wheel numpy scipy

#install jdk8
cd /opt
$SUDO wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.tar.gz"
$SUDO tar xzf jdk-8u141-linux-x64.tar.gz
cd /opt/jdk1.8.0_141/
$SUDO alternatives --install /usr/bin/java java /opt/jdk1.8.0_141/bin/java 2
#$SDUO alternatives --install /usr/bin/jar jar /opt/jdk1.8.0_141/bin/jar 2
$SUDO alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_141/bin/javac 2

#insatll bazel
# tensorflow v1.3.0-rc1 branch cannot build with bazel-0.5.3
# use 0.5.2
cd ~
curl -LO https://github.com/bazelbuild/bazel/releases/download/0.5.2/bazel-0.5.2-dist.zip
unzip bazel-0.5.2-dist.zip -d bazel && cd bazel
./compile.sh
$SUDO cp output/bazel /usr/local/bin/bazel

#install tensorflow
cd ~
git clone https://github.com/tensorflow/tensorflow -b v1.3.0-rc1
cd tensorflow
#if you are using pyenv, make sure disable pyenv environment configuration
#otherwise, it will cause error because of the shim wrapper
./configure
bazel build -c opt --copt=-mavx --copt=-mavx2 --copt=-mfma --copt=-msse4.2 --copt=-mfpmath=both --config=cuda -k //tensorflow/tools/pip_package:build_pip_package
bazel-bin/tensorflow/tools/pip_package/build_pip_package tensorflow_pkg
cd ~
$SUDO pip install tensorflow/tensorflow_pkg/tensorflow-1.3.0rc1-cp27-cp27mu-linux_x86_64.whl
#test with python;import tensorflow as tf
