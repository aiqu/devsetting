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

FILENAME=`basename ${BASH_SOURCE[0]}`
FILENAME=${FILENAME%%.*}
DONENAME="DONE$FILENAME"
if [ ! -z ${!DONENAME+x} ];then
  return 0
fi
let DONE$FILENAME=1

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

source $ROOT/envset.sh

if [ $OS == 'mac' ];then
  exit 0
fi

source "$HOME/.bashrc"

iecho "Python installation.. install location: $LOCAL_DIR"

function install_python {
  VER=$1
  WORKDIR="/tmp/tmp_$VER"
  mkdir -p $WORKDIR && cd $WORKDIR
  curl -L https://www.python.org/ftp/python/$VER/Python-$VER.tar.xz | tar xJf -
  cd Python-$VER
  LDFLAGS="-L${LOCAL_DIR}/lib -L${LOCAL_DIR}/lib64" ./configure \
    --prefix=${LOCAL_DIR} \
    --enable-shared \
    --enable-unicode=ucs4 \
    --with-threads \
    --with-system-ffi \
    --without-ensurepip
  make -s -j$(nproc)
  make -s install 1>/dev/null
  rm -rf $WORKDIR

  cd $HOME
  MAJOR_VER=$(echo $VER | awk -F'.' '{print $1}')
  if [ ! -f ${LOCAL_DIR}/bin/pip$MAJOR_VER ]; then
    curl -L https://bootstrap.pypa.io/get-pip.py | ${LOCAL_DIR}/bin/python$MAJOR_VER
  fi
}

PYTHON2_VER='2.7.14'
PYTHON3_VER='3.6.3'
INSTALLED_PYTHON2_VER=$(${LOCAL_DIR}/bin/python2 --version 2>&1 | grep Python | awk '{print $2}')
INSTALLED_PYTHON3_VER=$(${LOCAL_DIR}/bin/python3 --version 2>&1 | grep Python | awk '{print $2}')

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_PYTHON2_VER ] || [ $PYTHON2_VER != $INSTALLED_PYTHON2_VER ]; then
  install_python $PYTHON2_VER
else
  gecho "Python $PYTHON2_VER is already installed"
fi

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_PYTHON3_VER ] || [ $PYTHON3_VER != $INSTALLED_PYTHON3_VER ]; then
  install_python $PYTHON3_VER
else
  gecho "Python $PYTHON3_VER is already installed"
fi

pip2 install -Uq pip
pip3 install -Uq pip

pip2 install -q jupyter jupyterthemes
pip3 install -q jupyter jupyterthemes
jt -t grade3 -f source -fs 95 -altp -tfs 11 -nfs 115 -cellw 88% -T
cp $ROOT/resources/jupyter/jupyter_notebook_config.py $HOME/.jupyter/
cp -r $ROOT/resources/jupyter/kernels ${LOCAL_DIR}/share/jupyter/
