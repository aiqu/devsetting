#!/bin/bash
#
#    Base setting for development environment
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

ROOT=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)

. $ROOT/envset.sh

. $ROOT/install_scripts/configurations.sh
. $ROOT/install_scripts/dependencies.sh
. $ROOT/install_scripts/bash_completion.sh
. $ROOT/install_scripts/autojump.sh
. $ROOT/install_scripts/git.sh
. $ROOT/install_scripts/vim.sh
. $ROOT/install_scripts/python.sh
