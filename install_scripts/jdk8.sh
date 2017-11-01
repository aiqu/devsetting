#!/bin/bash

set -e

WORKDIR=$HOME/.local

mkdir -p $WORKDIR && cd $WORKDIR

FILENAME='jdk-8u152-linux-x64.tar.gz'
FOLDERNAME='jdk1.8.0_152'

wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u152-b16/aa0333dd3019491ca4f6ddbe78cdb6d0/$FILENAME"
tar xf $FILENAME && rm $FILENAME
ln -s $HOME/.local/$FOLDERNAME/bin/* $HOME/.local/bin/
