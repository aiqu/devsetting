#!/usr/bin/env bash
#
#    Docker installer
#     - Refered docker official guide
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

iecho "Docker Installation.. install location: $LOCAL_DIR"
if [ $OS == "ubuntu" ];then
    ${SUDO} apt-get update -y
    ${SUDO} apt-get remove -y docker docker-engine docker.io
    ${SUDO} apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
    curl --retry 10 -fsSL https://download.docker.com/linux/ubuntu/gpg | ${SUDO} apt-key add -
    ${SUDO} add-apt-repository -y \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"
    ${SUDO} add-apt-repository -y \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       edge"
    ${SUDO} apt-get update -y
    ${SUDO} apt install -y docker-ce
elif [ $OS == "debian" ];then
    ${SUDO} apt-get update -y
    ${SUDO} apt-get remove -y docker docker.io
    ${SUDO} apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common
    curl --retry 10 -fsSL https://download.docker.com/linux/debian/gpg | ${SUDO} apt-key add -
    ${SUDO} add-apt-repository -y \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) \
       stable"
    ${SUDO} add-apt-repository -y \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) \
       edge"
    ${SUDO} apt-get update -y
    ${SUDO} apt install -y docker-ce
elif [ $OS == "centos" ];then
    set +e
    ${SUDO} yum update -y
    set -e
    ${SUDO} yum remove -y docker docker-common docker-selinux docker-engine
    ${SUDO} yum install -y yum-utils device-mapper-persistent-data lvm2
    ${SUDO} yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    ${SUDO} yum makecache fast
    ${SUDO} yum install -y docker-ce
    ${SUDO} systemctl start docker
    ${SUDO} docker run --rm hello-world
elif [ $OS == "mac" ];then
    curl --retry 10 -L https://download.docker.com/mac/stable/Docker.dmg -o $HOME/Docker.dmg
    iecho "Run $HOME/Docker.dmg manually"
fi

# Install docker-compose
${SUDO} curl --retry 10 -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose
${SUDO} chmod +x /usr/bin/docker-compose
