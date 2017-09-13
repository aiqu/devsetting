#!/bin/bash

if [ ! -d install_scripts ];then
	ROOT=$(pwd)/..
else
	ROOT=$(pwd)
fi

. envset.sh

source "$ROOT/install_scripts/dependencies.sh"
source "$ROOT/nosudo.sh"
