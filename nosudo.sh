#!/bin/bash

if [ ! -d install_scripts ];then
	ROOT=$(pwd)/..
else
	ROOT=$(pwd)
fi

. envset.sh

DEPENDENCIES_DONE=true
source "$ROOT/install_scripts/configurations.sh"
source "$ROOT/install_scripts/git.sh"
source "$ROOT/install_scripts/vim.sh"
source "$ROOT/install_scripts/python.sh"
