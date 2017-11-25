#!/bin/bash

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="curl"
TMP_DIR=$ROOT/tmp
REPO_URL="https://github.com/curl/curl"
TAG=$(git ls-remote -t $REPO_URL | grep -v '{}\|pre' | grep curl | cut -d/ -f3 | sort -V | tail -n1)
VER=$(echo $TAG | sed 's/curl-//' | sed 's/_/./g')
FOLDER="$PKG_NAME*"
VERFILE=""
INSTALLED_VERSION=$(curl --version | head -n1 | cut -d' ' -f2 | sed 's/-DEV//')

if [ ! -z $REINSTALL ] || [ ! -f $HOME/.local/bin/curl ]; then
  echo "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"

  mkdir -p $TMP_DIR && cd $TMP_DIR
  curl -LO $REPO_URL/archive/$TAG.zip
  $HOME/.local/bin/unzip -q $TAG.zip && rm -rf $TAG.zip && cd $FOLDER
  ./buildconf
  ./configure --prefix=$HOME/.local \
    --disable-debug \
    --enable-optimize \
    --disable-curldebug \
    --enable-http \
    --enable-ftp \
    --enable-file \
    --enable-ldap \
    --enable-ldaps \
    --enable-rtsp \
    --enable-proxy \
    --enable-dict \
    --enable-telnet \
    --enable-tftp \
    --enable-pop3 \
    --enable-imap \
    --enable-smb \
    --enable-smtp \
    --enable-gopher \
    --enable-manual \
    --enable-libcurl-option \
    --enable-libgcc \
    --enable-ipv6 \
    --enable-threaded-resolver \
    --enable-sspi \
    --enable-crypto-auto \
    --enable-tls-srp \
    --enable-unix-sockets \
    --enable-cookies && \
    make -j$(nproc) && make install

  cd $ROOT && rm -rf $TMP_DIR
else
  echo "$PKG_NAME $INSTALLED_VERSION is already installed"
fi

cd $ROOT
