#!/bin/bash

set -e

VER='4.3'
WORKDIR=$HOME/.local

mkdir -p $WORKDIR && cd $WORKDIR

curl -LO https://services.gradle.org/distributions/gradle-$VER-bin.zip
unzip -oq gradle-$VER-bin.zip && rm gradle-$VER-bin.zip
ln -s $(pwd)/gradle-$VER/bin/gradle $HOME/.local/bin/gradle
