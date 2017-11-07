#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

bash $ROOT/install_scripts/libevent.sh
bash $ROOT/install_scripts/ncurses.sh

TMP_DIR=$ROOT/tmp
REPO_URL=https://github.com/tmux/tmux
TAG=$(git ls-remote --tags $REPO_URL | awk -F/ '{print $3}' | grep -v '{}' | sort -V | tail -n1)
FOLDER="tmux-$(echo $TAG | sed 's/v//')"
INSTALLED_VERSION=$(tmux -V | cut -d' ' -f2)

if [ -z $INSTALLED_VERSION ] || [ $TAG != $INSTALLED_VERSION ]; then
  echo "tmux $TAG installation.. pwd: $PWD, root: $ROOT, core: $CORE"

  mkdir -p $TMP_DIR && cd $TMP_DIR

  curl -LO ${REPO_URL}/archive/${TAG}.zip
  unzip -q ${TAG}.zip
  cd $FOLDER
  echo $(pwd)
  ./autogen.sh && ./configure --prefix=$HOME/.local
  make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "tmux $INSTALLED_VERSION is already installed"
fi

cd $ROOT
