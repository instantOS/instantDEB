#!/bin/bash

if [ -e "PKGBUILD" ]; then
    echo "PKGBUILD not found"
    exit 1
fi

[ -e .debcache ] && rm -rf .debcache

mkdir .debcache
cp PKGBUILD debcache/
cd .debcache
/usr/share/instantdeb/controlgen.sh
mkdir -p package/DEBIAN
mv control package/DEBIAN/
export pkgdir="$(realpath ./package)"
source PKGBUILD

if ! echo $source | grep -q 'git\+'; then
    echo "no git source found"
    exit
fi

prepare
build
package
