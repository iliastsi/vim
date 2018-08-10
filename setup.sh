#!/bin/bash

set -e

path=$(cd `dirname $0` && pwd)

if [ "$path" != "$(dirname ~/.vim/setup.sh)" ]; then
    echo "[E] This file should be located in ~/.vim"
    exit 1
fi

if [ ! -e ~/.vimrc ]; then
    echo "~/.vim/vimrc -> ~/.vimrc"
    ln -s ~/.vim/vimrc ~/.vimrc
else
    echo "[E] ~/.vimrc exists... aborting"
    exit 1
fi

# Install vim-plug
if [ ! -e ~/.vim/autoload/plug.vim ]; then
    echo "Installing vim-plug"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
    echo "[E] ~/.vim/autoload/plug.vim exists... aborting"
    exit 1
fi

# Install bundles
echo | vim -c ":PlugInstall" -c ":qall"
