#!/bin/bash
#
#    Gradle installer
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

VER='4.3'
WORKDIR=$HOME/.local

mkdir -p $WORKDIR && cd $WORKDIR

curl -LO https://services.gradle.org/distributions/gradle-$VER-bin.zip
unzip -oq gradle-$VER-bin.zip && rm gradle-$VER-bin.zip
ln -s $(pwd)/gradle-$VER/bin/gradle $HOME/.local/bin/gradle
