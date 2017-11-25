#!/bin/bash
#
#    nginx installer
#
#    Copyright (C) 2017 Gwangmin Lee
#    
#    Author: Gwangmin Lee <gwangmin0123@gmail.com>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

VER='1.13.5'
PCRE='pcre-8.41'
ZLIB='zlib-1.2.11'
OPENSSL='openssl-1.0.2k'
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
