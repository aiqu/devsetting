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

SRC_DIR=$HOME
BAZEL_DIR=${SRC_DIR}/bazel
TF_SRC_DIR=${SRC_DIR}/tensorflow
TF_PKG_DIR=${TF_SRC_DIR}/tensorflow_pkg

#install prerequisites
$SUDO yum install epel-release
$SUDO yum update
$SUDO yum groupinstall 'Development Tools'
$SUDO yum install which wget git unzip zip python-devel.x86_64 python-pip python-wheel numpy scipy

#install jdk8
if ! java -version 2>&1 | grep -q '1.8' || ! javac -version 2>&1 | grep -q '1.8' || ! which jar 2>/dev/null ;then
    cd /opt
    JDK_FILENAME=jdk-8u141-linux-x64.tar.gz
    $SUDO wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/$JDK_FILENAME"
    $SUDO tar xzf $JDK_FILENAME
    $SUDO rm $JDK_FILENAME
    cd /opt/jdk1.8.0_141/
    $SUDO alternatives --install /usr/bin/java java /opt/jdk1.8.0_141/bin/java 2
    $SUDO alternatives --install /usr/bin/jar jar /opt/jdk1.8.0_141/bin/jar 2
    $SUDO alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_141/bin/javac 2
    $SUDO alternatives --set java /opt/jdk1.8.0_141/bin/java
    $SUDO alternatives --set jar /opt/jdk1.8.0_141/bin/jar
    $SUDO alternatives --set javac /opt/jdk1.8.0_141/bin/javac
fi

#insatll bazel
# tensorflow v1.3.0-rc1 branch cannot build with bazel-0.5.3
# use 0.5.2
if ! bazel version | grep -q '0.5.2' ;then
    cd $SRC_DIR
    curl -LO https://github.com/bazelbuild/bazel/releases/download/0.5.2/bazel-0.5.2-dist.zip
    unzip -q bazel-0.5.2-dist.zip -d bazel && cd bazel
    ./compile.sh
    $SUDO cp output/bazel /usr/local/bin/bazel
fi

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
