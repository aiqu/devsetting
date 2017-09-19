#!/bin/bash

set -e

VER='1.13.5'
PCRE='pcre-8.41'
ZLIB='zlib-1.2.11'
OPENSSL='openssl-1.0.2k'
ROOT=$(pwd)
WORKDIR=$ROOT/tmp

mkdir -p $WORKDIR && cd $WORKDIR

curl -L http://nginx.org/download/nginx-${VER}.tar.gz | tar xzf -
curl -L ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${PCRE}.tar.gz | tar xzf -
curl -L http://zlib.net/${ZLIB}.tar.gz | tar xzf -
curl -L http://www.openssl.org/source/${OPENSSL}.tar.gz | tar xzf -

cd $WORKDIR/$PCRE
./configure --prefix=$HOME/.local
make -j$(nproc)
make install

cd $WORKDIR/$ZLIB
./configure --prefix=$HOME/.local
make -j$(nproc)
make install

cd $WORKDIR/$OPENSSL
./config --prefix=$HOME/.local
make -j$(nproc)
make install

cd $WORKDIR/nginx-${VER}
./configure --prefix=$HOME/.local/nginx \
    --sbin-path=$HOME/.local/bin/nginx \
    --with-http_ssl_module \
    --with-pcre=../${PCRE} \
    --with-zlib=../${ZLIB} \
    --with-openssl=../${OPENSSL}

make -j$(nproc)
make install

cd $ROOT && rm -rf $WORKDIR
