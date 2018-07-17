#!/usr/bin/env bash
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

. $ROOT/envset.sh
. $ROOT/install_scripts/zlib.sh
. $ROOT/install_scripts/readline.sh
. $ROOT/install_scripts/openssl.sh

if [ $OS == 'mac' ];then
  brew install python3
else
  source "$HOME/.bashrc"

  iecho "Python installation.. install location: $LOCAL_DIR"

  if [ ! -r /usr/include/bzlib.h ] && [ ! -r /usr/local/include/bzlib.h ] && [ ! -r $LOCAL_DIR/include/bzlib.h ];then
    REINSTALL=1 $ROOT/install_scripts/bzip2.sh
  fi
  if [ ! -r /usr/include/lzma.h ] && [ ! -r /usr/local/include/lzma.h ] && [ ! -r $LOCAL_DIR/include/lzma.h ];then
    REINSTALL=1 $ROOT/install_scripts/xz.sh
  fi

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
      --with-system-ffi
    make -s -j${NPROC}
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
  INSTALLED_PYTHON2_VER=
  if hash python2 2>/dev/null;then
    INSTALLED_PYTHON2_VER=$(${LOCAL_DIR}/bin/python2 --version 2>&1 | grep Python | awk '{print $2}')
  fi
  INSTALLED_PYTHON3_VER=
  if hash python3 2>/dev/null;then
    INSTALLED_PYTHON3_VER=$(${LOCAL_DIR}/bin/python3 --version 2>&1 | grep Python | awk '{print $2}')
  fi

  #if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_PYTHON2_VER ] || [ $PYTHON2_VER != $INSTALLED_PYTHON2_VER ]; then
    #install_python $PYTHON2_VER
  #else
    #gecho "Python $PYTHON2_VER is already installed"
  #fi

  if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_PYTHON3_VER ] || $(compare_version $INSTALLED_PYTHON3_VER $PYTHON3_VER); then
    install_python $PYTHON3_VER
    ln -sf $LOCAL_DIR/bin/python3 $LOCAL_DIR/bin/python
  else
    gecho "Python $PYTHON3_VER is already installed"
  fi
fi

if [ ! -z $PYTHON_PACKAGE ];then
  #pip2 install -Uq pip
  pip3 install -Uq pip

  #pip2 install -q jupyter jupyterthemes flake8
  pip3 install -q jupyter jupyterthemes flake8
  jt -t grade3 -f source -fs 95 -altp -tfs 11 -nfs 115 -cellw 88% -T
  cp $ROOT/resources/jupyter/jupyter_notebook_config.py $HOME/.jupyter/
  cp -r $ROOT/resources/jupyter/kernels ${LOCAL_DIR}/share/jupyter/

  if [ ! -d $HOME/.config ];then
    mkdir $HOME/.config
  fi
  ln -sf $ROOT/configurations/flake8 $HOME/.config/flake8
fi

LEVEL=$(( ${LEVEL}-1 ))
