#!/bin/bash

if [ ! -d install_scripts ];then
	ROOT=$(pwd)/..
else
	ROOT=$(pwd)
fi

source "$ROOT/install_scripts/dependencies.sh"
source "$ROOT/install_scripts/configurations.sh"
source "$ROOT/install_scripts/git.sh"
source "$ROOT/install_scripts/vim.sh"
