#!/bin/bash

set -e

DOCKER_DONE=

if [ ! -d configurations ];then
	ROOT=$(pwd)/..
else
	ROOT=$(pwd)
fi

if [ ! $CONFIGURATIONS_DONE ];then
    $($ROOT/install_scripts/dependencies.sh)
fi

echo "Docker Installation.. pwd: $PWD, root: $ROOT, core: $CORE"

if [ $(echo $OSTYPE | grep linux) ];then
    sudo apt-get remove docker docker-engine docker.io
    sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"
    sudo apt-get update
    sudo apt install docker-ce
else [ $(echo $OSTYPE | grep darwin) ];then
    curl -L https://download.docker.com/mac/stable/Docker.dmg -o $HOME/Docker.dmg
fi

DOCKER_DONE=1
