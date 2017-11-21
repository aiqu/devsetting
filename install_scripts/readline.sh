#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="readline"
TMP_DIR=$ROOT/tmp
REPO_URL="https://git.savannah.gnu.org/git/readline.git"
DOWN_URL="http://git.savannah.gnu.org/cgit/readline.git/snapshot"
TAG=$(git ls-remote -t $REPO_URL | grep -v -e '{}\|alpha\|beta\|rc' | cut -d/ -f3 | sort -V | tail -n1)
VER=$(echo $TAG | sed 's/readline-//')
FOLDER="$PKG_NAME*"
VERFILE="$HOME/.local/include/readline/readline.h"
INSTALLED_VERSION=$(cat $VERFILE | grep 'define RL_READLINE_VERSION' | cut -d' ' -f4)

if [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -L $DOWN_URL/$TAG.tar.gz | tar xz && cd $FOLDER
  ./configure --prefix=$HOME/.local && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $VER is already installed"
fi

cd $ROOT
