#!/bin/bash

var1=10
var2=20

echo "(($var1+$var2))"
echo "$(($var1 + $var2))"

declar -i "COUNT=5"
COUNT="COUNT+1"

echo "count is : $COUNT"