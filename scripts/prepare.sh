#!/bin/bash

SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
FONT="$SCRIPT_DIR/../AnomalyMono-Regular.otf"
PWRL="$SCRIPT_DIR/../AnomalyMono-Powerline.otf"

$SCRIPT_DIR/powerline-mod.sh "$FONT"
mv Anomaly\ Mono.otf "$PWRL"
gftools fix-dsig --autofix "$FONT"
gftools fix-unwanted-tables "$FONT"
fontbakery check-universal "$FONT"
