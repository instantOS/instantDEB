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

# fetch all sources
for src in "${source[@]}"; do
    echo "fetching ${src}"
    if grep -q 'git\+' <<<"$src" &&
        grep -q 'https://.*\..*/.*' <<<"$src"; then
        echo "git source found"
        GITSOURCE=$(grep -o 'https://.*\..*/.*' <<<"$src")

        if grep -q '::' <<<"$src"; then
            SOURCENAME=$(grep -o '^[^:]*' <<<"$src")
        else
            SOURCENAME=gitsource
        fi
        git clone --depth=1 "$GITSOURCE" "$SOURCENAME"
    else
        echo "no git source found"
        exit
    fi
done

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
