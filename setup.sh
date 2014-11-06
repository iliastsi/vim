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

# Clone vundle
if [ ! -e  $path/bundle/vundle ]; then
    echo "Cloning vundle"
    git clone git://github.com/gmarik/vundle.git $path/bundle/vundle
else
    echo "[E] $path/bundle/vundle exists.. aborting"
    exit 1
fi

# Install bundles
echo | vim -c ":PluginInstall" -c ":qall"
