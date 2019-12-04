#!/bin/bash

bold=$(tput bold)
red='\033[0;31m'
green='\033[0;32m'
ltcyan='\033[0;96m'
normal=$(tput sgr0)
nc='\033[0m'

BREAK="\n=========================================\n"

function runFontBakery () {
    echo -e "${ltcyan}Running $1...${nc}"
    sleep 1
    fontbakery $1 *.otf
    case "$?" in
        0)
            echo -e "$BREAK"
            echo -e "$1 : ${green}${bold}PASSED${normal}${nc}"
            echo -e "$BREAK"
            ;;
        1)
            echo -e "$BREAK"
            echo -e "$1 : ${red}${bold}FAILED${normal}${nc}"
            echo -e "$BREAK"
            exit 1
            ;;
    esac
}

if ! [ -x "$(command -v fontbakery)" ]; then
    echo -e "\n${red}${bold}Please install fontbakery before running this script.${normal}${nc}\n\nYou can view how to do so here: https://font-bakery.readthedocs.io/en/latest/user/installation/index.html"
    exit 1
fi

runFontBakery "check-googlefonts"
runFontBakery "check-adobefonts"
runFontBakery "check-fontval"
