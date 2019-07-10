#!/bin/bash

clear
echo ""
read -r -d '' DEMO_STRING << EOM
Anomaly Mono

ABCDEFGHIJKLMNOPQRSTUVWXYZ
abcdefghijklmnopqrstuvwxyz
012346789
!@#$%^&*()
EOM

columns="$(tput cols)"
while read -r line; do
    printf "%*s\n" $(( (${#line} + columns) / 2)) "$line"
done <<< "$DEMO_STRING"
