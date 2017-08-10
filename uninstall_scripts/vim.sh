#!/bin/bash

if [ ! $ROOT ];then
    if [ ! -d 'uninstall_scripts' ];then
        ROOT=$(pwd)/..
    else
        ROOT=$(pwd)
    fi
fi

cd $ROOT/repo/vim
make uninstall
