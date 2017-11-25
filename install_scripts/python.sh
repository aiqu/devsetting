#!/bin/bash
#
#    Python installer
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

if [ $OS == 'mac' ];then
  exit 0
fi

source "$HOME/.bashrc"

echo "Python installation.. pwd: $PWD, root: $ROOT"

function install_python {
  VER=$1
  WORKDIR="/tmp/tmp_$VER"
  mkdir -p $WORKDIR && cd $WORKDIR
  curl -L https://www.python.org/ftp/python/$VER/Python-$VER.tar.xz | tar xJf -
  cd Python-$VER
  ./configure \
    --prefix=$HOME/.local \
    --enable-shared \
    --enable-unicode=ucs4 \
    --with-threads \
    --with-system-ffi \
    --without-ensurepip
  make -s -j$(nproc) && make -s install 1>/dev/null 1>/dev/null
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

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_PYTHON2_VER ] || [ $PYTHON2_VER != $INSTALLED_PYTHON2_VER ]; then
  install_python $PYTHON2_VER
else
  echo "Python $PYTHON2_VER is already installed"
fi

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_PYTHON3_VER ] || [ $PYTHON3_VER != $INSTALLED_PYTHON3_VER ]; then
  install_python $PYTHON3_VER
else
  echo "Python $PYTHON3_VER is already installed"
fi

pip2 install -U pip
pip3 install -U pip

pip2 install jupyter jupyterthemes
pip3 install jupyter jupyterthemes
jt -t grade3 -f source -fs 95 -altp -tfs 11 -nfs 115 -cellw 88% -T
