#!/bin/bash

var1=10
var2=20
var3=siva

echo "$var1+$var2"
echo "$(($var1+$var2+$var3))"

declare -i COUNT=5 # I am declaring as integer
COUNT=COUNT+1

echo "Count is: $COUNT"

FRUITS=("Apple" "Banana" "Pappaya") # This is called as array
echo "All fruits: ${FRUITS[@]}"
echo "First fruit: ${FRUITS[1]}"

name="Sivakumar Reddy M"

echo "${name}ettukuru"