#!/bin/bash

set -e

path=$(cd `dirname $0` && pwd)

ask() {
    local prompt default answer

    if [ "$2" = "Y" ]; then
        prompt="Y/n"
        default=Y
    elif [ "$2" = "N" ]; then
        prompt="y/N"
        default=N
    else
        prompt="y/n"
        default=
    fi

    while true; do
        read -p "$1 [$prompt] " answer

        # Default
        if [ -z "$answer" ]; then
            answer=$default
        fi

        case $answer in
            [Yy]*) return 0;;
            [Nn]*) return 1;;
        esac
    done
}

if [ "$path" != "$(dirname ~/.vim/setup.sh)" ]; then
    echo "[E] This file should be located in ~/.vim"
    exit 1
fi

# Configure plugins
plugins=$(ask "Enable plugins" Y; echo $?)

if [ $plugins -eq 0 ]; then
    plugins_ide=$(ask "Enable IDE like functionality (ALE/Coc)" Y; echo $?)
else
    plugins_ide=1
fi

spell_el=$(ask "Create Greek dictionary (requires myspell-el-gr)" Y; echo $?)

# Create symlink
if [ ! -e ~/.vimrc ]; then
    echo "~/.vim/vimrc -> ~/.vimrc"
    ln -s ~/.vim/vimrc ~/.vimrc
fi

# Configure vim
: > ~/.vim/settings.vimrc

if [ $plugins -eq 0 ]; then
    # Install vim-plug
    if [ ! -e ~/.vim/autoload/plug.vim ]; then
        echo "Installing vim-plug"
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
    echo "let g:vimrc_settings_plugins = 1" >> ~/.vim/settings.vimrc
else
    echo "let g:vimrc_settings_plugins = 0" >> ~/.vim/settings.vimrc
fi

if [ $plugins_ide -eq 0 ]; then
    echo "let g:vimrc_settings_plugins_ide = 1" >> ~/.vim/settings.vimrc
else
    echo "let g:vimrc_settings_plugins_ide = 0" >> ~/.vim/settings.vimrc
fi

if [ $spell_el -eq 0 ]; then
    if [ ! -f ~/.vim/spell/el.utf-8.spl ]; then
        vim -e -c "mkspell ~/.vim/spell/el /usr/share/hunspell/el_GR" -c "qa"
    fi
    echo "let g:vimrc_settings_spell_el = 1" >> ~/.vim/settings.vimrc
else
    echo "let g:vimrc_settings_spell_el = 0" >> ~/.vim/settings.vimrc
fi

# Install bundles
vim -e -c "PlugInstall --sync" -c "qall"

echo Done
