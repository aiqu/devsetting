#!/usr/bin/env bash

PYTHONE_DONE=

set -e

if [ ! -d configurations ];then
    ROOT=$(pwd)/..
else
    ROOT=$(pwd)
fi

source "$HOME/.bashrc"

echo "Python installation.. pwd: $PWD, root: $ROOT"

function install_python {
  VER=$1
  WORKDIR="/tmp/tmp_$VER"
  mkdir -p $WORKDIR && cd $WORKDIR
  curl -L https://www.python.org/ftp/python/$VER/Python-$VER.tar.xz | tar xJf -
  cd Python-$VER
  ./configure --prefix=$HOME/.local --enable-shared
  make -j$(nproc)
  make install
  rm -rf $WORKDIR

  cd $HOME
  MAJOR_VER=$(echo $VER | awk -F'.' '{print $1}')
  if [ ! -f $HOME/.local/bin/pip$MAJOR_VER ]; then
    curl -L https://bootstrap.pypa.io/get-pip.py | $HOME/.local/bin/python$MAJOR_VER
  fi
}

PYTHON2_VER='2.7.13'
PYTHON3_VER='3.6.3'
INSTALLED_PYTHON2_VER=$($HOME/.local/bin/python2 --version 2>&1 | grep Python | awk '{print $2}')
INSTALLED_PYTHON3_VER=$($HOME/.local/bin/python3 --version 2>&1 | grep Python | awk '{print $2}')

if [ -z $INSTALLED_PYTHON2_VER ] || [ $PYTHON2_VER != $INSTALLED_PYTHON2_VER ]; then
  install_python $PYTHON2_VER
else
  echo "Python $PYTHON2_VER is already installed"
fi

if [ -z $INSTALLED_PYTHON3_VER ] || [ $PYTHON3_VER != $INSTALLED_PYTHON3_VER ]; then
  install_python $PYTHON3_VER
else
  echo "Python $PYTHON3_VER is already installed"
fi

pip2 install -U pip
pip3 install -U pip

pip install jupyter jupyterthemes
jt -t grade3 -f source -fs 95 -altp -tfs 11 -nfs 115 -cellw 88% -T

echo "---"
echo "Type \"source $ENVFILE\""

PYTHONE_DONE=1
