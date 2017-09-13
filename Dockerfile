FROM centos:7.3.1611

RUN yum update -y && \
        yum install -y epel-release && \
        yum update -y && \
        yum install -y git sudo && \
        cd $HOME && mkdir .lib && cd .lib && \
        git clone https://github.com/aiqu/devsetting.git && \
        cd devsetting && bash all.sh
