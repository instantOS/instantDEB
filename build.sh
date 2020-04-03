#!/bin/bash

echo "starting pkgbuild deb"

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
export "$(realpath ./package)"
source PKGBUILD

if grep -q 'git\+' <<<"$source" &&
    grep -q 'https://.*\..*/.*' <<<"$source"; then
    echo "git source found"
    GITSOURCE=$(grep -o 'https://.*\..*/.*' <<<"$source")
    
    if grep -q '::' <<<"$source"; then
        SOURCENAME=$(grep -o '^[^:]*' <<<"$source")
    else
        SOURCENAME=gitsource
    fi

    git clone --depth=1 "$GITSOURCE" "$SOURCENAME"
    export _pkgname=$(realpath ./$SOURCENAME)
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
mv output/*.deb ../"$pkgname".deb
cd ..

if ! [ -e ~/.paperdebug ]; then
    rm -rf .debcache
fi

echo "done building $pkgname"
