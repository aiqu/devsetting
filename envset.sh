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
        eecho "Unknown linux distro"
        exit 1
    fi
elif [ $(echo $OSTYPE | grep 'darwin') ];then
    ENVFILE="$HOME/.bash_profile"
    OS="mac"
else
    eecho "Unkown distro"
    exit 1
fi

SET_BOLD="\e[1m"
UNSET_BOLD="\e[0m"
COLOR_RED="\e[38;5;9m"
COLOR_YELLOW="\e[38;5;11m"
COLOR_GREEN="\e[38;5;2m"
COLOR_INFO="\e[38;5;14m"
COLOR_NONE="\e[38;m"

function eecho {
  echo -e "${SET_BOLD}${COLOR_RED}$1${COLOR_NONE}${UNSET_BOLD}"
}

function wecho {
  echo -e "${SET_BOLD}${COLOR_YELLOW}$1${COLOR_NONE}${UNSET_BOLD}"
}

function gecho {
  echo -e "${SET_BOLD}${COLOR_GREEN}$1${COLOR_NONE}${UNSET_BOLD}"
}

function iecho {
  echo -e "${SET_BOLD}${COLOR_INFO}$1${COLOR_NONE}${UNSET_BOLD}"
}

# Given two arguments, true if first argument is smaller version than second argument
function compare_version {
  if [ $# != 2 ];then
    eecho "compare_version requires exactly two arguments!!!"
    return 1
  fi

  if [ "$(echo -e "$1\n$2" | sort -V | head -n1)" = "$1" ];then
    return 0
  else
    return 1
  fi
}

if [ -f $ENVFILE ];then
  . $ENVFILE
fi
