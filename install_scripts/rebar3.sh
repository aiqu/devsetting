#!/bin/bash

set -e

if [ ! $(which erl 2>/dev/null) ];then
  echo "Rebar3 requires erlang"
  exit 1
fi

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)

PKG_NAME="Rebar3"
TMP_DIR=$ROOT/tmp
REPO_URL="https://github.com/erlang/rebar3"
TAG=$(git ls-remote -t $REPO_URL | grep -v -e '{}\|alpha\|beta' | cut -d/ -f3 | sort -V | tail -n1)
FOLDER="rebar3-$TAG"
INSTALLED_VERSION=$(rebar3 -v | cut -d' ' -f2)

if [ -z $INSTALLED_VERSION ] || [ $TAG != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $TAG installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -LO $REPO_URL/archive/$TAG.zip
  unzip -q $TAG.zip && rm -rf $TAG.zip && cd $FOLDER
  ./bootstrap && mv rebar3 $HOME/.local/bin

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $INSTALLED_VERSION is already installed"
fi

cd $ROOT
