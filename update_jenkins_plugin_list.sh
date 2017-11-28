#!/bin/bash
#
#    Pull out jenkins installed plugin list
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

if [ $# != 3 ];then
  echo -e "Usage: ./$(basename $0) JENKINS_ADDR USERNAME PASSWORD"
  exit 1
fi

USERNAME=$2
PASSWORD=$3

JENKINS_HOST=$1
JENKINS_CLI='jenkins-cli.jar'
JENKINS_PLUGINS='jenkins_plugins.txt'

curl "$JENKINS_HOST/jnlpJars/$JENKINS_CLI" > $JENKINS_CLI

GROOVY_SCRIPT='def plugins = jenkins.model.Jenkins.instance.getPluginManager().getPlugins()\nplugins.each {println "${it.getShortName()}:${it.getVersion()}"}'
TMPFILE='__tmp_groovy__'
echo -e $GROOVY_SCRIPT > $TMPFILE
java -jar $JENKINS_CLI -s $JENKINS_HOST groovy --username $USERNAME --password $PASSWORD = < $TMPFILE | grep -v ndeploy > resources/$JENKINS_PLUGINS
rm $TMPFILE $JENKINS_CLI
