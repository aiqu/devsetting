#!/bin/bash

set -e

GIT_DONE=

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
. $ROOT/envset.sh

TMP_DIR=$ROOT/tmp
PKG='git'
REPO_URL='https://github.com/git/git'
TAG=$(git ls-remote -t $REPO_URL | grep -v -e '{}\|rc' | cut -d/ -f3 | sort -V | tail -n1)
VER=$(echo $TAG | sed 's/v//')
FOLDER="$PKG*"
INSTALLED_VERSION=$(git --version 2>/dev/null | awk '{print $3}')

if [ -z $REINSTALL ] && [ $VER == $INSTALLED_VERSION ];then
    echo "$PKG $VER is already installed"
else
    echo "$PKG $VER installation.. pwd: $PWD, root: $ROOT"

    if [ $OS == "mac" ]; then
        export XML_CATALOG_FILES=/usr/local/etc/xml/catalog
        ALIAS_FILE='/usr/local/bin/docbook2texi'
        ln -fs $ALIAS_FILE /usr/local/bin/docbook2x-texi

        if brew ls --versions docbook-xsl; then
            brew install docbook-xsl
        else
            brew upgrade docbook-xsl
        fi
    fi

    mkdir -p $TMP_DIR && cd $TMP_DIR
    curl -LO $REPO_URL/archive/$TAG.zip && unzip -q $TAG.zip && rm $TAG.zip
    cd $FOLDER
    export CC=gcc
    export LDFLAGS=-L$HOME/.local/lib
    make configure && ./configure --prefix=$HOME/.local --with-openssl --with-curl
    make -j$(nproc) all && make install
    cd $ROOT && rm -rf $TMP_DIR
fi

cd $ROOT

GIT_DONE=1
