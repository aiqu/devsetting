#!/bin/bash

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
