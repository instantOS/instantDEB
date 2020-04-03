#!/bin/bash

# convert pkg

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

if [ "$1" = "build" ]; then
    /usr/share/ideb/build.sh
    exit
fi
