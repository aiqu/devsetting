#!/bin/bash

if [ ! -f configurations ];then
	ROOT=$(pwd)/..
else
	ROOT=$(pwd)
fi

CONF_FOLDER=`readlink -f $ROOT/configurations`

for f in `ls $CONF_FOLDER/.[^\.]*`;do
	ln -si $f $HOME/
done

BIN_FOLDER=`readlink -f $ROOT/bin`

mkdir -p $HOME/bin

for f in `ls $BIN_FOLDER/*`;do
	ln -si $f $HOME/bin/
done

