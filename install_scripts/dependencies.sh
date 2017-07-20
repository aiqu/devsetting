#!/bin/bash

if [[ $OSTYPE == *'linux'* ]]; then
	PKG_LIST="git \
		build-essential \
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
		"
	sudo apt update
	sudo apt install $PKG_LIST
elif [[ $OSTYPE == *'darwin'* ]]; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	PKG_LIST="git \
		cmake \
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
		"
	brew install $PKG_LIST
	alias ctags="`brew --prefix`/bin/ctags"
    alias readlink=greadlink
fi
