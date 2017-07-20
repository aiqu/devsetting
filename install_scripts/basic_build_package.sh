#!/bin/bash

PKG_LIST="git \
	build-essential \
	cmake \
	libncurses5-dev \
	"
sudo apt update
sudo apt install $PKG_LIST
