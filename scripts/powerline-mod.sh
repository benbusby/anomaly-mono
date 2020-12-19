#!/bin/bash

SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

if ! [[ -x "$(command -v fontforge)" ]]; then
    echo "Please install the fontforge command line tool before running this script"
    exit 1
fi

fontforge \
    -script "$SCRIPT_DIR/../nerd-fonts/font-patcher" \
    -l -s --powerline --powerlineextra --progressbars $1
