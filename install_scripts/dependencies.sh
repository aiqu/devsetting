#!/bin/bash

set -e

DEPENDENCIES_DONE=

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)

. $ROOT/envset.sh

echo "Dependencies installation.. pwd: $PWD, root: $ROOT"

if [ $OS == "mac" ]; then
    set +e
    xcode-select --install
    which -s brew
    if [ $? != 0 ];then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        brew update
    fi
fi

. $ROOT/install_scripts/make.sh
. $ROOT/install_scripts/m4.sh
. $ROOT/install_scripts/libtool.sh
. $ROOT/install_scripts/autoconf.sh
. $ROOT/install_scripts/automake.sh
. $ROOT/install_scripts/which.sh
. $ROOT/install_scripts/pkg-config.sh
. $ROOT/install_scripts/ncurses.sh
. $ROOT/install_scripts/unzip.sh
. $ROOT/install_scripts/gettext.sh
. $ROOT/install_scripts/readline.sh
. $ROOT/install_scripts/openssl.sh
. $ROOT/install_scripts/zlib.sh
. $ROOT/install_scripts/curl.sh
. $ROOT/install_scripts/bzip2.sh
. $ROOT/install_scripts/libarchive.sh
. $ROOT/install_scripts/libexpat.sh
. $ROOT/install_scripts/cmake.sh
. $ROOT/install_scripts/texinfo.sh
. $ROOT/install_scripts/cscope.sh
. $ROOT/install_scripts/ctags.sh
. $ROOT/install_scripts/libconfuse.sh
. $ROOT/install_scripts/sqlite.sh
. $ROOT/install_scripts/perl-extutiles-makemaker.sh

. $ROOT/install_scripts/byobu.sh

DEPENDENCIES_DONE=1
