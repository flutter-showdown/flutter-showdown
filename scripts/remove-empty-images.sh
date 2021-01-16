#!/bin/sh

# Remove empty images after splitting a iconsheet with holes
# e.g. the item icon sheet

for img in $(ls)
do
  if [[ $(wc -c < $img) == *"274"* ]]
  then
    rm $img
  fi
done