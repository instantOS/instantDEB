#!/bin/bash

if [ -e "PKGBUILD" ]; then
    echo "PKGBUILD not found"
    exit 1
fi

rm -rf .debcache
mkdir .debcache
cp PKGBUILD debcache/
cd .debcache
/usr/share/instantdeb/controlgen.sh
