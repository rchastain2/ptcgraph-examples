#!/bin/sh

set -e

cd "$(dirname "$0")"

magick -size 320x240 xc:white +antialias \
  -fill '#E03030' -draw 'rectangle 40,40 139,139' \
  -fill '#3070E0' -draw 'rectangle 110,90 209,189' \
  -fill '#F0C020' -draw 'rectangle 180,40 279,139' \
  -type truecolor -compress none BMP3:bmpview1.bmp

magick -size 320x240 xc:'#2040A0' +antialias \
  -fill '#F0D020' -draw 'rectangle 80,40 239,199' \
  -fill '#2040A0' -draw 'rectangle 110,70 209,169' \
  -fill white -draw 'rectangle 140,100 179,139' \
  -colors 8 -type palette test.gif

magick -size 256x256 xc:'#E0E0E0' +antialias \
  -fill '#20A040' -draw 'rectangle 24,24 103,103' \
  -fill '#E03030' -draw 'rectangle 88,88 167,167' \
  -fill '#3070E0' -draw 'rectangle 152,152 231,231' \
  -fill '#F0C020' -draw 'rectangle 112,112 143,143' \
  -colors 8 -type palette PNG8:loadpng1.png
