#!/bin/bash
for f in *.scss; do sass-convert $f ${f%scss}sass ; done 
rm *.scss
