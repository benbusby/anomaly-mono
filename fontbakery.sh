#!/bin/bash

function runFontBakery () {
    echo "Starting $1 (press Enter to continue)"
    read -p ""
    fontbakery $1 *.otf
}

if ! [ -x "$(command -v fontbakery)" ]; then
    echo -e "\n${red}${bold}Please install fontbakery before running this script.${normal}${nc}\n\nYou can view how to do so here: https://font-bakery.readthedocs.io/en/latest/user/installation/index.html"
    exit 1
fi

runFontBakery "check-googlefonts"
runFontBakery "check-adobefonts"
runFontBakery "check-fontval"
