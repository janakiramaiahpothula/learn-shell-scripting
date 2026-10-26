#!/bin/bash


echo "Please enter marks"
read marks

if 
    [ $marks -lt 33 ]; then
    echo "faile"
elif  [ $marks -lt 50 ]; then
    echo "third class"
elif  [ $marks -lt 60 ]; then
    echo "second class"
elif  [ $marks -lt 75 ]; then
    echo "first class"
else 
    echo "distaction"
fi
echo  "End"