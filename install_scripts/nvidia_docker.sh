#!/usr/bin/env bash
#
#    <nvidia_docker> installer
#
#    Copyright (C) 2018 Gwangmin Lee
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
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME='nvidia_docker'
iecho "$PKG_NAME $VER installation.."
# Referenced https://github.com/NVIDIA/nvidia-docker
# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
if [ $OS = 'centos' ];then
  set -e
  ${SUDO} yum remove nvidia-docker
  set +e

  # Add the package repositories
  curl --retry 10 -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo | \
    ${SUDO} tee /etc/yum.repos.d/nvidia-docker.repo

  # Install nvidia-docker2
  ${SUDO} yum install -y nvidia-docker2
elif [ $OS = 'ubuntu' ];then
  set +e
  ${SUDO} apt purge -y nvidia-docker
  set -e

  # Add the package repositories
  curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
  curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
    sudo tee /etc/apt/sources.list.d/nvidia-docker.list
  sudo apt update

  # Install nvidia-docker2
  sudo apt install -y nvidia-docker2
fi
# Reload the Docker daemon configuration
${SUDO} pkill -SIGHUP dockerd

# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi

iecho "$PKG_NAME successfully installed"
iecho "you may want to add \"default-runtime\": \"nvidia\" to /etc/docker/daemon.json"

LEVEL=$(( ${LEVEL}-1 ))
