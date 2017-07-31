#!/bin/bash

PYTHONE_DONE=

set -e

if [ ! -d configurations ];then
    ROOT=$(pwd)/..
else
    ROOT=$(pwd)
fi

if [ ! $DEPENDENCIES_DONE ];then
    source "$ROOT/install_scripts/dependencies.sh"
fi

echo "Pyenv installation.. pwd: $PWD, root: $ROOT"

mkdir -p $HOME/.lib

if ! grep -q "PYENV_ROOT" "$ENVFILE" ;then
    echo '## PYENV CONFIGURATION ##' >> $ENVFILE
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $ENVFILE
    echo 'export PATH=$PYENV_ROOT/bin:$PATH' >> $ENVFILE
    echo 'eval "$(pyenv init -)"' >> $ENVFILE
    echo 'eval "$(pyenv virtualenv-init -)"' >> $ENVFILE
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

pyenv install 2.7.13
pyenv install 3.6.1

echo "---"
echo "Type \"source $ENVFILE\""

PYTHONE_DONE=1
