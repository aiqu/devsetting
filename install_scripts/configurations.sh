#!/usr/bin/env bash
#
#    Personal environment configuration script
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

if [ $(echo $OSTYPE | grep 'linux') ];then
    READLINK='readlink'
elif [ $OS == "mac" ];then
    READLINK='greadlink'
fi

iecho "Configurations. install location: $LOCAL_DIR"

CONF_FOLDER=`$READLINK -f $ROOT/configurations`

for f in `ls -d $CONF_FOLDER/.[^\.]*`;do
    if [ -d $HOME/$(basename $f) ];then
        rm -rf $HOME/$(basename $f)
    fi
    ln -sf $f $HOME/$(basename $f)
done

BIN_FOLDER=`$READLINK -f $ROOT/bin`

mkdir -p $HOME/bin

for f in `ls $BIN_FOLDER/*`;do
	ln -sf $f $HOME/bin/
done
