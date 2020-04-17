#!/bin/bash

##############################################
## a tool to build PKGBUILD files on debian ##
## or convert pkg files to deb packages     ##
##############################################

if [ -z "$1" ]; then
    echo "Usage: ideb filename.pkg.tar.xz"
    exit
fi

if ! command -v dpkg &>/dev/null; then
    echo "please run this on a debian system"
    exit 1
fi

case "$1" in
build)
    /usr/share/ideb/build.sh
    ;;
install)
    /usr/share/ideb/build.sh && sudo dpkg -i *.deb
    ;;
control)
    /usr/share/ideb/controlgen.sh
    ;;
*)
    /usr/share/ideb/convert.sh "$1"
    ;;
esac
