#!/usr/bin/env bash
#
#    Git installer
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

PKG='git'
REPO_URL='https://github.com/git/git'
TAG=$(git ls-remote -t $REPO_URL | grep -v -e '{}\|rc' | cut -d/ -f3 | sort -V | tail -n1)
if [ $LEVEL -le 1 ];then
  TAG=${CUSTOMTAG:-$TAG}
fi
VER=$(echo $TAG | sed 's/v//')
FOLDER="$PKG*"
INSTALLED_VERSION=
if hash git 2>/dev/null;then
  INSTALLED_VERSION=$(git --version 2>/dev/null | awk '{print $3}')
fi

if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_VERSION ] || $(compare_version $INSTALLED_VERSION $VER);then
  iecho "$PKG $VER installation.. install location: $LOCAL_DIR"

  if [ $OS == "mac" ]; then
    export XML_CATALOG_FILES=/usr/local/etc/xml/catalog
    ALIAS_FILE='/usr/local/bin/docbook2texi'
    ln -fs $ALIAS_FILE /usr/local/bin/docbook2x-texi

    if brew ls --versions docbook-xsl; then
      brew install docbook-xsl
    else
      brew upgrade docbook-xsl
    fi
  fi

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -LO $REPO_URL/archive/$TAG.zip
  unzip -q $TAG.zip && rm $TAG.zip
  cd $FOLDER
  export CC=gcc
  export LDFLAGS=-L${LOCAL_DIR}/lib
  make -s configure
  ./configure --prefix=${LOCAL_DIR} --with-openssl --with-curl
  make -s -j${NPROC} all
  make -s install 1>/dev/null

  cd $ROOT && rm -rf $TMP_DIR
else
  gecho "$PKG $VER is already installed"
fi

LEVEL=$(( ${LEVEL}-1 ))
cd $ROOT
