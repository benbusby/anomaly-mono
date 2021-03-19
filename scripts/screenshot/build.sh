#!/bin/bash
# Requires imagemagick to convert from ppm to png

python font2c.py
make
./draw_text
convert anomaly_mono.ppm anomaly_mono.png
