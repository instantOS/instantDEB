#!/bin/bash

if ! [ -e "$1" ]; then
    echo "package file $1 not found"
    exit 1
fi
