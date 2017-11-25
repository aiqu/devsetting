#!/bin/bash
#
#    set profile function to bashrc
#     - Modified https://github.com/dkim010/settings/set_profile.sh
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
## Originated from https://github.com/dkim010/settings
## command: . set_profile.sh

if [ -z $1 ]; then
  echo 'insert username'
else
  ROOT=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
  PROFILE_PATH_HOME=$HOME/users
  USER_NAME=$1

  ## profile setting
  cp ${ROOT}/func_profile $HOME
  if ! grep -q PROFILE_PATH_HOME $HOME/.bashrc ; then
    echo -e "export PROFILE_PATH_HOME=$PROFILE_PATH_HOME\nif [ -f \$HOME/func_profile ]; then\n  . \$HOME/func_profile\nfi" >> $HOME/.bashrc
  fi

  mkdir -p $HOME/users/$USER_NAME
fi
