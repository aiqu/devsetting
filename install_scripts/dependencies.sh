#!/bin/bash
#
#    Basic library installer or other packages
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
. $ROOT/install_scripts/gettext.sh
. $ROOT/install_scripts/readline.sh
. $ROOT/install_scripts/zlib.sh
. $ROOT/install_scripts/bzip2.sh
. $ROOT/install_scripts/libarchive.sh
. $ROOT/install_scripts/unzip.sh
. $ROOT/install_scripts/libexpat.sh
. $ROOT/install_scripts/openssl.sh
. $ROOT/install_scripts/curl.sh
. $ROOT/install_scripts/cmake.sh
. $ROOT/install_scripts/texinfo.sh
. $ROOT/install_scripts/cscope.sh
. $ROOT/install_scripts/ctags.sh
. $ROOT/install_scripts/libconfuse.sh
. $ROOT/install_scripts/sqlite.sh
. $ROOT/install_scripts/perl-extutiles-makemaker.sh

. $ROOT/install_scripts/byobu.sh
