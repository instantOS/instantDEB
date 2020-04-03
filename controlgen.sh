#!/bin/bash

# generate a debian control file from a PKGBUILD

if ! [ -e PKGBUILD ]; then
    echo "PKGBUILD not found"
    exit 1
fi

source PKGBUILD

echo "Package: $pkgname" >control
if type pkgver; then
    pkgver="$(pkgver)"
fi

echo "Version: $pkgver" >>control
echo "Architecture: ${arch:-any}" >>control
echo "Maintainer: instantDEB <paperbenni@gmail.com>" >>control
echo "Depends: bash" >>control
echo "Recommends: bash" >>control
echo "Section: misc" >>control
echo "Priority: optional" >>control

if [ -n "$pkgdesc" ]; then
    echo "Description: $pkgdesc" >>control
else
    echo "Description: auto generated package by instantDEB" >>control
fi

echo "Original-Maintainer: paperbenni <paper.benni@gmail.com>" >>control
