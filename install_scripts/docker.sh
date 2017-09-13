#!/bin/bash

set -e

DOCKER_DONE=

if [ ! -d configurations ];then
	ROOT=$(pwd)/..
else
	ROOT=$(pwd)
fi

. $ROOT/envset.sh

echo "Docker Installation.. pwd: $PWD, root: $ROOT, core: $CORE"
if [ $OS == "ubuntu" ] || [ $OS == "debian" ];then
    ${SUDO} apt-get remove -y docker docker-engine docker.io
    ${SUDO} apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | ${SUDO} apt-key add -
    ${SUDO} add-apt-repository -y \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"
    ${SUDO} apt-get update -y
    ${SUDO} apt install -y docker-ce
elif [ $OS == "centos" ];then
    ${SUDO} yum remove -y docker docker-common docker-selinux docker-engine
    ${SUDO} yum install -y yum-utils device-mapper-persistent-data lvm2
    ${SUDO} yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    ${SUDO} yum makecache fast
    ${SUDO} yum install -y docker-ce
    ${SUDO} systemctl start docker
    ${SUDO} docker run --rm hello-world
elif [ $OS == "mac" ];then
    curl -L https://download.docker.com/mac/stable/Docker.dmg -o $HOME/Docker.dmg
    echo "Run $HOME/Docker.dmg manually"
fi

DOCKER_DONE=1
