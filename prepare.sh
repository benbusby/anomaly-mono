#!/bin/bash

./powerline-mod.sh AnomalyMonoRegular.otf
mv Anomaly\ Mono.otf AnomalyMonoPowerline.otf
gftools fix-dsig --autofix AnomalyMonoRegular.otf
gftools fix-unwanted-tables AnomalyMonoRegular.otf
fontbakery check-universal AnomalyMonoRegular.otf
