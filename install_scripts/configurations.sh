#!/bin/bash

CONF_FOLDER=`readlink -f $(pwd)/../configurations`

for f in `ls $CONF_FOLDER/.[^\.]*`;do
	echo ln -s $f $HOME/
done

BIN_FOLDER=`readlink -f $(pwd)/../bin`

for f in `ls $BIN_FOLDER/*`;do
	echo ln -s $f $HOME/bin/
done

