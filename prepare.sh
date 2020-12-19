#!/bin/bash

./powerline-mod.sh AnomalyMono-Regular.otf
mv Anomaly\ Mono.otf AnomalyMono-Powerline.otf
gftools fix-dsig --autofix AnomalyMono-Regular.otf
gftools fix-unwanted-tables AnomalyMono-Regular.otf
fontbakery check-universal AnomalyMono-Regular.otf
