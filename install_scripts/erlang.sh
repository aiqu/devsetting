#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)

PKG_NAME="Erlang"
TMP_DIR=$ROOT/tmp
REPO_URL="https://github.com/erlang/otp"
TAG=$(git ls-remote -t $REPO_URL | grep -v -e '{}\|R\|_' | cut -d/ -f3 | sort -V | tail -n1)
VER=$(echo $TAG | cut -d'-' -f2)
FOLDER="otp-$TAG"
INSTALLED_VERSION=$(find $HOME/.local/lib/erlang/releases -name OTP_VERSION | xargs cat | sort -V | tail -n1)

if [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $TAG installation.. pwd: $PWD, root: $ROOT, core: $CORE"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -LO $REPO_URL/archive/$TAG.zip
  unzip -q $TAG.zip && rm -rf $TAG.zip && cd $FOLDER
  export ERL_TOP=$(pwd)
  ./otp_build autoconf && ./configure --prefix=$HOME/.local && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
  unset ERL_TOP
else
  echo "$PKG_NAME $INSTALLED_VERSION is already installed"
fi

bash $ROOT/install_scripts/rebar3.sh

cd $ROOT
