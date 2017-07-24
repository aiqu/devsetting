#!/bin/bash

set -e

GIT_DONE=

if [ ! $ROOT ];then
    if [ ! -d 'install_scripts' ];then
        ROOT=$(pwd)/..
    else
        ROOT=$(pwd)
    fi
fi

if [ ! $CONFIGURATIONS_DONE ];then
    source "$ROOT/install_scripts/configurations.sh"
fi

echo "Git installation.. pwd: $PWD, root: $ROOT, core: $CORE"

TAG=2.14.0-rc0

if [ $(echo $OSTYPE | grep 'darwin') ]; then
    export XML_CATALOG_FILES=/usr/local/etc/xml/catalog
    ALIAS_FILE='/usr/local/bin/docbook2texi'
    ln -fs $ALIAS_FILE /usr/local/bin/docbook2x-texi

    if brew ls --versions docbook-xsl; then
        brew install docbook-xsl
    else
        brew upgrade docbook-xsl
    fi
fi

mkdir -p $HOME/.lib
cd $HOME/.lib
FILENAME=v${TAG}.zip
if [ ! -f $FILENAME ];then
    curl -LO https://github.com/git/git/archive/${FILENAME}
    unzip ${FILENAME}
fi
cd git-${TAG}
make configure
./configure --prefix=$HOME/.local
make -j$CORE all doc && make install install-doc
cd $PWD

GIT_DONE=1
