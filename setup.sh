#!/bin/bash

set -e

path=$(cd `dirname $0` && pwd)

if [ "$path" != "$(dirname ~/.vim/setup.sh)" ]; then
    echo "[E] This file should be located in ~/.vim"
    exit 1
fi

if [ ! -e ~/.vimrc ]; then
    echo "$path/vimrc -> ~/.vimrc"
    ln -s $path/vimrc ~/.vimrc
else
    echo "[E] ~/.vimrc exists.. aborting"
    exit 1
fi

# Initialize submodules
cd $path
git submodule update --init --remote --rebase
cd -
