#!/bin/bash

set -e

CONFIGURATIONS_DONE=

if [ ! $ROOT ];then
    if [ ! -d 'install_scripts' ];then
        ROOT=$(pwd)/..
    else
        ROOT=$(pwd)
    fi
fi

if [ ! $DEPENDENCIES_DONE ];then
    source "$ROOT/install_scripts/dependencies.sh"
fi

if [ $(echo $OSTYPE | grep 'linux') ];then
	READLINK='readlink'
    CORE=$(cat /proc/cpuinfo | grep processor | wc -l)
elif [ $(echo $OSTYPE | grep 'darwin') ];then
	READLINK='greadlink'
    CORE=$(sysctl -n hw.ncpu)
fi

echo "Configurations. pwd: $PWD, root: $ROOT, core: $CORE"

CONF_FOLDER=`$READLINK -f $ROOT/configurations`

for f in `ls $CONF_FOLDER/.[^\.]*`;do
	ln -sf $f $HOME/
done

BIN_FOLDER=`$READLINK -f $ROOT/bin`

mkdir -p $HOME/bin

for f in `ls $BIN_FOLDER/*`;do
	ln -sf $f $HOME/bin/
done

CONFIGURATIONS_DONE=1
