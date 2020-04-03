#!/bin/bash

# installs ideb
# doesnt use package management because its a special snowflake

echo "installing ideb"

# local install if run in directory,
# fetch from github if ran from other sources
if ! [ -e ideb.sh ]; then
    mkdir -p ~/.cache/ideb
    cd ~/.cache/ideb
    git clone --depth=1 https://github.com/instantos/instantDEB
    cd instantDEB
else
    git pull
fi

chmod +x ./*.sh

sudo cp ideb.sh /usr/bin/ideb
sudo chmod 755 /usr/bin/ideb

[ -e /usr/share/ideb ] || sudo mkdir -p /usr/share/ideb

sudo cp *.sh /usr/share/ideb
sudo chmod 755 /usr/share/ideb/*
