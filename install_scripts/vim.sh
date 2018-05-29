#!/usr/bin/env bash
#
#    vim installer
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

FILENAME=`basename ${BASH_SOURCE[0]}`
FILENAME=${FILENAME%%.*}
DONENAME="DONE$FILENAME"
if [ ! -z ${!DONENAME+x} ];then
  return 0
fi
let DONE$FILENAME=1

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
. $ROOT/envset.sh

PKG_NAME="vim"
REPO_URL=https://github.com/vim/vim
TAG=$(git ls-remote --tags $REPO_URL | awk -F/ '{print $3}' | grep -v '{}' | sort -V | tail -n1)
VER=$TAG
FOLDER="vim-$(echo $TAG | sed 's/v//')"
INSTALLED_VERSION=v$(vim --version | head -1 | awk '{print $5}').$(vim --version | grep 'patches:'| awk -F'-' '{print $2}' | cut -d',' -f1)

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $(compare_version $INSTALLED_VERSION $VER) ]; then
  iecho "$PKG_NAME $VER installation.. install location: $LOCAL_DIR"

  mkdir -p $TMP_DIR && cd $TMP_DIR

  curl -LO ${REPO_URL}/archive/${TAG}.zip
  unzip -q ${TAG}.zip
  cd $FOLDER

  LOCAL_DIR_STR=$(echo "$LOCAL_DIR" | sed 's|/|\\/|g')
  if [ $OS == 'mac' ];then
    sed -i '' 's/#CONF_ARGS = --with-modified-by="John Doe"/CONF_ARGS = --with-modified-by="Gwangmin Lee"/' src/Makefile
    sed -i '' 's/#CONF_OPT_GUI = --disable-gui/CONF_OPT_GUI = --disable-gui/' src/Makefile
    sed -i '' 's/#CONF_OPT_PYTHON = --enable-pythoninterp/CONF_OPT_PYTHON = --enable-pythoninterp/' src/Makefile
    sed -i '' 's/#CONF_OPT_PYTHON3 = --enable-python3interp/CONF_OPT_PYTHON3 = --enable-python3interp/' src/Makefile
    sed -i '' 's/#CONF_OPT_CSCOPE = --enable-cscope/CONF_OPT_CSCOPE = --enable-cscope/' src/Makefile
    sed -i '' 's/#CONF_OPT_TERMINAL = --enable-terminal/CONF_OPT_TERMINAL = --enable-terminal/' src/Makefile
    sed -i '' 's/#CONF_OPT_MULTIBYTE = --enable-multibyte/CONF_OPT_MULTIBYTE = --enable-multibyte/' src/Makefile
    sed -i '' 's/#CONF_OPT_GPM = --disable-gpm/CONF_OPT_GPM = --disable-gpm/' src/Makefile
    sed -i '' 's/#CONF_OPT_SYSMOUSE = --disable-sysmouse/CONF_OPT_SYSMOUSE = --disable-sysmouse/' src/Makefile
    sed -i '' 's/#prefix = \$(HOME)/prefix = '$LOCAL_DIR_STR'/' src/Makefile
  else
    sed -i 's/#CONF_ARGS = --with-modified-by="John Doe"/CONF_ARGS = --with-modified-by="Gwangmin Lee"/' src/Makefile
    sed -i 's/#CONF_OPT_GUI = --disable-gui/CONF_OPT_GUI = --disable-gui/' src/Makefile
    sed -i 's/#CONF_OPT_PYTHON = --enable-pythoninterp/CONF_OPT_PYTHON = --enable-pythoninterp/' src/Makefile
    sed -i 's/#CONF_OPT_PYTHON3 = --enable-python3interp/CONF_OPT_PYTHON3 = --enable-python3interp/' src/Makefile
    sed -i 's/#CONF_OPT_CSCOPE = --enable-cscope/CONF_OPT_CSCOPE = --enable-cscope/' src/Makefile
    sed -i 's/#CONF_OPT_TERMINAL = --enable-terminal/CONF_OPT_TERMINAL = --enable-terminal/' src/Makefile
    sed -i 's/#CONF_OPT_MULTIBYTE = --enable-multibyte/CONF_OPT_MULTIBYTE = --enable-multibyte/' src/Makefile
    sed -i 's/#CONF_OPT_GPM = --disable-gpm/CONF_OPT_GPM = --disable-gpm/' src/Makefile
    sed -i 's/#CONF_OPT_SYSMOUSE = --disable-sysmouse/CONF_OPT_SYSMOUSE = --disable-sysmouse/' src/Makefile
    sed -i 's/#prefix = \$(HOME)/prefix = '$LOCAL_DIR_STR'/' src/Makefile
  fi

  make -s -j${NPROC}
  make -s install 1>/dev/null

  cd $PWD
  rm -rf $TMP_DIR

  mkdir -p $HOME/.vim
  cd $HOME/.vim

  if [[ ! -d $HOME/.vim/bundle/Vundle.vim ]]
  then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  fi

  ${LOCAL_DIR}/bin/vim +PluginInstall +PluginUpdate +qall
  unzip -qu $ROOT/resources/taglist_46.zip -d ~/.vim/
  cp $ROOT/resources/ejs.vim ${LOCAL_DIR}/share/vim/vim80/syntax/ejs.vim

  if [[ ! -d $HOME/.vim/pack/plugins/start/vim-go ]]; then
    git clone https://github.com/fatih/vim-go.git $HOME/.vim/pack/plugins/start/vim-go
    ${LOCAL_DIR}/bin/vim +GoInstallBinaries +qall
  fi
else
  gecho "$PKG_NAME $VER is already installed"
fi

cd $ROOT
