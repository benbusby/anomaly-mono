#!/bin/bash


if ! [[ -x "$(command -v fontforge)" ]]; then
    echo "Please install the fontforge command line tool before running this script"
    exit 1
fi

fontforge -script ./nerd-fonts/font-patcher -l -s --powerline --powerlineextra --progressbars $1
