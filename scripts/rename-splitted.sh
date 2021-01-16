#!/bin/sh

# Launch this script inside the split folder

# split an iconsheet
# https://www.pictools.net/split/

# https://play.pokemonshowdown.com/sprites/itemicons-sheet.png
# https://play.pokemonshowdown.com/sprites/pokemonicons-sheet.png

# item images are 24*24
# pokemon icons images are 30*40

i=0
for img in $(ls)
do
 mv $img $i.png; ((i++))
done
