#!/bin/bash

set -e

CONFIGURATIONS_DONE=

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

if [ $(echo $OSTYPE | grep 'linux') ];then
    READLINK='readlink'
    CORE=$(cat /proc/cpuinfo | grep processor | wc -l)
elif [ $OS == "mac" ];then
    READLINK='greadlink'
    CORE=$(sysctl -n hw.ncpu)
fi

echo "Configurations. pwd: $PWD, root: $ROOT, core: $CORE"

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

CONFIGURATIONS_DONE=1
