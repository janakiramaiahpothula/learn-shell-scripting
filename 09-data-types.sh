#!/bin/bash

var1=10
var2=20

echo "(($var1+$var2))"
echo "$(($var1 + $var2))"

declare -i "COUNT=5"
COUNT="COUNT+1"

echo "count is : $COUNT"

STUDENTS=("Sai" "Ram" "Varun")
echo "All Students: ${STUDENTS[@]}"
echo "Frist Student Name: ${STUDENTS[1]}"

name="Shivakumar Reddy M"
echo "${name}etukuri"