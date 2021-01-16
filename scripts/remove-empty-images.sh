#!/bin/sh

# Remove empty images after splitting a iconsheet with holes
# e.g. the item icon sheet

for img in $(ls)
do
  if [[ $(file $img) == *"grayscale"* ]]
  then
    rm $img
  fi
done