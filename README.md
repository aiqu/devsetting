[![Build Status](https://travis-ci.org/aiqu/devsetting.svg?branch=master)](https://travis-ci.org/aiqu/devsetting)

#### Usage

`./base.sh # run basic install scripts`

`REINSTALL=1 [INSTALL_SCRIPT] # run install scripts with force reinstall`


#### Docker images
```
# centos7 with development group packages installed
gwangmin/centos_7_dev
# centos_7_dev with gcc5 installed
gwangmin/centos_7_gcc_5
# centos_7_dev with gcc7 installed
gwangmin/centos_7_gcc_7
# centos_7_dev with ./base.sh installed
gwangmin/base:latest

# Jenkins with docker in docker
gwangmin/jenkins_did
# Jenkins slave image for jenkins_did
gwangmin/jenkins_slave_did
```
