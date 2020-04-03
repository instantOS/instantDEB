#!/bin/bash

if ! [ -e "PKGBUILD" ]; then
    echo "PKGBUILD not found"
    exit 1
fi

[ -e .debcache ] && rm -rf .debcache

mkdir .debcache
cp PKGBUILD .debcache/
cd .debcache
pushd .
/usr/share/ideb/controlgen.sh
mkdir -p package/DEBIAN
mv control package/DEBIAN/
export pkgdir="$(realpath ./package)"
source PKGBUILD

if grep -q 'git\+' <<<"$source" &&
    grep -q 'https://.*\..*/.*' <<<"$source"; then
    echo "git source found"
    GITSOURCE=$(grep -o 'https://.*\..*/.*' <<<"$source")
    git clone --depth=1 "$GITSOURCE" ./gitsource
    export _pkgname=$(realpath ./gitsource)
else
    echo "no git source found"
    exit
fi

prepare
build
package
popd
mkdir output
dpkg-deb -Z xz -b package/ output/
