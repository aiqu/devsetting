#!/usr/bin/env bash
#
#    Gradle installer
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

. $ROOT/install_scripts/unzip.sh

PKG_NAME='gradle'
REPO_URL="https://github.com/gradle/gradle"
TAG=$(git ls-remote -t $REPO_URL | grep -v '{}\|RC' | cut -d/ -f3 | sort -V | tail -n1)
CUSTOMTAGNAME="$(echo ${PKG_NAME} | sed 's/-//')TAG"
TAG=${!CUSTOMTAGNAME:-$TAG}
VER=$(echo $TAG | sed 's/v//' | sed 's/\.0$//')
FOLDER="$PKG_NAME*"
VERFILE=""
INSTALLED_VERSION=
if hash -r gradle 2>/dev/null;then
  INSTALLED_VERSION=$(gradle --version | grep Gradle | cut -d' ' -f2)
fi

if ([ ! -z $REINSTALL ] && [ $LEVEL -le $REINSTALL ]) || [ -z $INSTALLED_VERSION ] ||  $(compare_version $INSTALLED_VERSION $VER);then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

  WORKDIR=${LOCAL_DIR}
  mkdir -p $WORKDIR && cd $WORKDIR
  curl --retry 10 -LO https://services.gradle.org/distributions/gradle-$VER-bin.zip
  unzip -oq gradle-$VER-bin.zip && rm gradle-$VER-bin.zip
  ln -sf $(pwd)/gradle-$VER/bin/gradle ${LOCAL_DIR}/bin/gradle
else
  gecho "$PKG_NAME $VER is already installed"
fi

LEVEL=$(( ${LEVEL}-1 ))
cd $ROOT
