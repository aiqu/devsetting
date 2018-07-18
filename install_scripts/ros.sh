#!/usr/bin/env bash
#
#    <packagename> installer
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

if [ $OS == 'ubuntu' ];then
  . $ROOT/install_scripts/python.sh

  CODENAME=$(cat /etc/os-release | grep VERSION_CODENAME | cut -d'=' -f2)
  ${SUCO} bash -c "echo \"deb http://packages.ros.org/ros/ubuntu $CODENAME main\" > /etc/apt/sources.list.d/ros-latest.list"
  ${SUDO} apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
  ${SUDO} apt update
  echo -e 'tzdata tzdata/Areas select Asia\ntzdata tzdata/Zones/Europe select Seoul' > preseed.txt
  ${SUDO} debconf-set-selections preseed.txt
  rm preseed.txt
  DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true ${SUDO} apt install -y ros-kinetic-ros-base
  pip install -y rosinstall rosinstall-generator wstool catkin_pkg
  echo "source /opt/ros/kinetic/setup.bash" >> $HOME/.bashrc
else
  iecho "Current OS($OS) does not support ROS"
fi

LEVEL=$(( ${LEVEL}-1 ))
cd $ROOT
