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
mkdir -p package/DEBIAN
mkdir src

export pkgdir="$(realpath ./package)"
export srcdir="$(realpath ./src)"
export "$(realpath ./package)"
source PKGBUILD

echo "Dependencies: $depends"
echo "Make dependencies: $makedepends"

if [ -n "$install" ]; then
    if [ -e "$install" ]; then
        echo "copying install script"
        cp "$install" package/DEBIAN/postinst
        chmod +x package/DEBIAN/postinst
    fi
fi

# fetch all sources
for src in "${source[@]}"; do
    echo "fetching ${src}"

    if grep -q '::' <<<"$src"; then
        SOURCENAME=$(grep -o '^[^:]*' <<<"$src")
    fi

    if grep -q '\+.*/' <<<"$src"; then
        echo "version control system detected"
        if grep -q 'git\+' <<<"$src" &&
            grep -q 'https://.*\..*/.*' <<<"$src"; then
            echo "git source found"
            GITSOURCE=$(grep -o 'https://.*\..*/.*' <<<"$src")

            if grep -q 'branch=.*$' <<<"$src"; then
                GITSOURCE="${GITSOURCE%\#*}"
                BRANCHNAME=$(grep -o 'branch=.*' <<<"$src" | grep -o '[^=]*$')
            else
                if git ls-remote "$GITSOURCE" | grep -q 'refs.heads.master'
                then
                    BRANCHNAME="master"
                else
                    BRANCHNAME="main"
                fi
            fi

            if [ -n "$SOURCENAME" ]; then
                git clone -b "$BRANCHNAME" --depth=1 "$GITOPTIONS""$GITSOURCE" "$SOURCENAME"
            else
                git clone -b "$BRANCHNAME" --depth=1 "$GITOPTIONS""$GITSOURCE"
            fi
        fi
    else
        if [ -n "$SOURCENAME" ]; then
            LINK="$(grep -o '::.*$' <<<"$src" | grep -Eo '[^:]{1,}:.*')"
        else
            LINK="$src"
        fi

        echo "downloading direct file"
        if [ -n "$SOURCENAME" ]; then
            wget -O "itempfile" "$LINK"
	    cp "itempfile" src/"$SOURCENAME"
	    mv itempfile "$SOURCENAME"
        else
            wget -O itempfile "$LINK"
	    cp itempfile src/"$(basename $LINK)"
	    mv itempfile "$(basename $LINK)"
        fi
    fi

    [ -n "$SOURCENAME" ] && unset SOURCENAME

done

for i in ./*; do
    if [ -d "$i" ]; then
        if [ -e "$i"/.git ]; then
            cp -r "$i" ./src/"$i"
            echo "copying git folder $i"
        else
            echo "skipping $i"
            continue
        fi
    fi

    FILETYPE="$(file -b $i)"
    echo "$FILETYPE"
    if grep -q '^Zip' <<<"$FILETYPE"; then
        unzip "$i" -d src/
    elif grep -q '^gzip' <<<"$FILETYPE"; then
        tar -xzf "$i" -C src/
    elif grep -q '^XZ' <<<"$FILETYPE"; then
        tar -xf "$i" -C src/
    else
        echo "$i not an archive"
    fi
done

cd src
INSTANTSRCDIR="$(pwd)"

fexit() {
    echo "build failed"
    exit
}

if type prepare &> /dev/null
then
	echo "ideb preparing"
	prepare || fexit
fi

if type build &> /dev/null
then
	echo "ideb building"
	build || fexit
fi

cd "$INSTANTSRCDIR"

if type package &> /dev/null
then
	echo "ideb packaging"
	package || fexit
fi

popd
pushd .
cp PKGBUILD src/PKGBUILD
cd src
/usr/share/ideb/controlgen.sh
popd
mv src/control package/DEBIAN/

mkdir output
if ! dpkg-deb -Z xz -b package/ output/
then
	echo "build failed"
	exit 1
fi

mv output/*.deb ../"$pkgname".deb
cd ..

if ! [ -e ~/.paperdebug ]; then
    rm -rf .debcache
fi

echo "done building $pkgname"
