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
    if [ -f /etc/lsb-release ]; then
        OS="ubuntu"
    elif [ -f /etc/redhat-release ];then
        OS="cent"
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
