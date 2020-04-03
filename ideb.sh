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
