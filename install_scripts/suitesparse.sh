#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

source $ROOT/envset.sh

PWD=$(pwd)
WORKDIR=$HOME/.lib

cd $WORKDIR
VER='4.5.6'
SRCFILE="SuiteSparse-$VER.tar.gz"
if [ ! -d SuiteSparse ]; then
  curl -L http://faculty.cse.tamu.edu/davis/SuiteSparse/$SRCFILE | tar xzf -
fi
cd SuiteSparse
make metis  # At this step, "No rule to make target 'w'" would happen. It is safe to ignore it.
make BLAS=-lblas library -j && make install INSTALL=$HOME/.local BLAS=-lblas
