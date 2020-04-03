#!/bin/bash

##############################################
## a tool to build PKGBUILD files on debian ##
## or convert pkg files to deb packages     ##
##############################################

if [ -z "$1" ]; then
    echo "Usage: ideb filename.pkg.tar.xz"
    exit
fi

if ! [ -e "$1" ]; then
    echo "file $1 not found"
    exit 1
fi

if ! command -v dpkg &>/dev/null; then
    echo "please run this on a debian system"
    exit 1
fi

case "$1" in
build)
    /usr/share/ideb/build.sh
    ;;
control)
    /usr/share/ideb/controlgen.sh
    ;;
esac
