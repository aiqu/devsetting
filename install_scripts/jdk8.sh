#!/bin/bash
#
#    JDK8 installer
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

WORKDIR=$HOME/.local

if ! java -version 2>&1 | grep -q '1.8' || ! javac -version 2>&1 | grep -q '1.8' || ! which jar 2>/dev/null ;then
  mkdir -p $WORKDIR && cd $WORKDIR

  FILENAME='jdk-8u152-linux-x64.tar.gz'
  FOLDERNAME='jdk1.8.0_152'

  wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u152-b16/aa0333dd3019491ca4f6ddbe78cdb6d0/$FILENAME"
  tar xf $FILENAME && rm $FILENAME
  ln -s $HOME/.local/$FOLDERNAME/bin/* $HOME/.local/bin/
else
  echo "JDK8 is already installed"
fi
