#!/bin/bash

set -e

VIM_DONE=

if [ ! $ROOT ];then
    if [ ! -d 'install_scripts' ];then
        ROOT=$(pwd)/..
    else
        ROOT=$(pwd)
    fi
fi

if [ ! $CONFIGURATIONS_DONE ];then
    source $ROOT/install_scripts/configurations.sh
fi

TMP_DIR=$ROOT/tmp
REPO_URL=https://github.com/vim/vim
TAG=$(git ls-remote --tags $REPO_URL | awk -F/ '{print $3}' | grep -v '{}' | sort -V | tail -n1)
FOLDER="vim-$(echo $TAG | sed 's/v//')"
INSTALLED_VERSION=v$(vim --version | head -1 | awk '{print $5}').$(vim --version | grep patches | awk -F'-' '{print $2}')

if [ -z $INSTALLED_VERSION ] || [ $TAG != $INSTALLED_VERSION ]; then
  echo "vim $TAG installation.. pwd: $PWD, root: $ROOT, core: $CORE"

  mkdir -p $TMP_DIR && cd $TMP_DIR

  curl -LO ${REPO_URL}/archive/${TAG}.zip
  unzip -q ${TAG}.zip
  cd $FOLDER

  sed -i 's/#CONF_ARGS = --with-modified-by="John Doe"/CONF_ARGS = --with-modified-by="Gwangmin Lee"/' src/Makefile
  sed -i 's/#CONF_OPT_GUI = --disable-gui/CONF_OPT_GUI = --disable-gui/' src/Makefile
  sed -i 's/#CONF_OPT_PYTHON = --enable-pythoninterp/CONF_OPT_PYTHON = --enable-pythoninterp/' src/Makefile
  sed -i 's/#CONF_OPT_PYTHON3 = --enable-python3interp/CONF_OPT_PYTHON3 = --enable-python3interp/' src/Makefile
  sed -i 's/#CONF_OPT_CSCOPE = --enable-cscope/CONF_OPT_CSCOPE = --enable-cscope/' src/Makefile
  sed -i 's/#CONF_OPT_TERMINAL = --enable-terminal/CONF_OPT_TERMINAL = --enable-terminal/' src/Makefile
  sed -i 's/#CONF_OPT_MULTIBYTE = --enable-multibyte/CONF_OPT_MULTIBYTE = --enable-multibyte/' src/Makefile
  sed -i 's/#CONF_OPT_GPM = --disable-gpm/CONF_OPT_GPM = --disable-gpm/' src/Makefile
  sed -i 's/#CONF_OPT_SYSMOUSE = --disable-sysmouse/CONF_OPT_SYSMOUSE = --disable-sysmouse/' src/Makefile
  sed -i 's/#prefix = \$(HOME)/prefix = \$(HOME)\/.local/' src/Makefile

  make -j$(nproc) && make install

  cd $PWD
  rm -rf $TMP_DIR

  mkdir -p $HOME/.vim
  cd $HOME/.vim

  if [[ ! -d $HOME/.vim/bundle/Vundle.vim ]]
  then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  fi

  $HOME/.local/bin/vim +PluginInstall +PluginUpdate +qall
  unzip -qu $ROOT/taglist_46.zip -d ~/.vim/
  curl -L https://raw.githubusercontent.com/ajh17/VimCompletesMe/master/plugin/VimCompletesMe.vim -o $HOME/.vim/plugin/VimCompletesMe.vim
else
  echo "Vim $INSTALLED_VERSION is already installed"
fi

VIM_DONE=1
