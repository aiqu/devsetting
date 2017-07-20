#!/bin/bash

if [[ $OSTYPE == *'linux'* ]]; then
	PKG_LIST="build-essential \
		cmake \
		libncurses5-dev \
		cscope \
		ctags \
		unzip \
		pkg-config \
		autoconf \
		automake \
		dh-autoreconf \
		autotools-dev \
		debhelper \
		libconfuse-dev \
        libssl-dev \
        libcurl4-openssl-dev \
        libexpat1-dev \
        openssh-server \
		"
	sudo apt update
	sudo apt install $PKG_LIST
elif [[ $OSTYPE == *'darwin'* ]]; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	PKG_LIST="cmake \
		ncurses \
		cscope \
		ctags \
		unzip \
		pkg-config \
		autoconf \
		automake \
		confuse \
        coreutils \
        curl \
        openssl \
        expat \
        openssh \
		"
	brew install $PKG_LIST
	alias ctags="`brew --prefix`/bin/ctags"
    alias readlink=greadlink
fi
