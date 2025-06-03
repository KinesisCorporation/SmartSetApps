#!/bin/bash

# each *.svg in this dir renders to *.png, *_150.png and *_200.png in upper dir

s150='_150'
s200='_200'

for f in *.svg
do
  rsvg-convert $f -w 24 -h 24 -o ../${f%.*}.png
  rsvg-convert $f -w 36 -h 36 -o ../${f%.*}$s150.png
  rsvg-convert $f -w 48 -h 48 -o ../${f%.*}$s200.png
done

