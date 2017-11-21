#!/bin/bash

ROOT=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)

. $ROOT/envset.sh

. $ROOT/install_scripts/configurations.sh
. $ROOT/install_scripts/dependencies.sh
. $ROOT/install_scripts/git.sh
. $ROOT/install_scripts/vim.sh
. $ROOT/install_scripts/python.sh
