#!/bin/bash

set -e

if [ ! $ROOT ];then
    if [ ! -d 'install_scripts' ];then
        ROOT=$(pwd)/..
    else
        ROOT=$(pwd)
    fi
fi

source $ROOT/envset.sh

PWD=$(pwd)
WORKDIR=$HOME/.lib

cd $WORKDIR
VER='4.5.5'
SRCFILE="SuiteSparse-$VER.tar.gz"
if [ ! -d SuiteSparse ]; then
  if [ ! -f $SRCFILE ]; then
    curl -LO http://faculty.cse.tamu.edu/davis/SuiteSparse/$SRCFILE
  fi
  tar xf $SRCFILE
fi
cd SuiteSparse
make metis  # At this step, "No rule to make target 'w'" would happen. It is safe to ignore it.
make BLAS=-lblas library -j && make install INSTALL=$HOME/.local BLAS=-lblas
