#!/bin/bash
#
#    Determin basic host env variable
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

if [ ! $ROOT ];then
    if [ ! -d 'configurations' ];then
        ROOT=$(pwd)/..
    else
        ROOT=$(pwd)
    fi
fi

PWD=$(pwd)
if [ $(whoami) != root ];then
    SUDO="sudo"
else
    SUDO=""
fi

if [ $(echo $OSTYPE | grep 'linux') ];then
    ENVFILE="$HOME/.bashrc"
    if [[ -f /etc/os-release ]]; then
        OS=$(cat /etc/os-release | grep ^ID= | sed 's/ID=[^a-zA-Z]*\([a-zA-Z]\+\)[^a-zA-Z]*/\1/')
    elif [ $(which yum 2>/dev/null) ]; then
        OS='centos'
    else
        echo "Unknown linux distro"
        exit 1
    fi
elif [ $(echo $OSTYPE | grep 'darwin') ];then
    ENVFILE="$HOME/.bash_profile"
    OS="mac"
else
    echo "Unkown distro"
    exit 1
fi

echo "Current OS is "$OS
if [ -f $ENVFILE ];then
  . $ENVFILE
fi
