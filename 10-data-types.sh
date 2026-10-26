#!/bin/bash


echo "Please enter marks"
read marks

if 
    [ $marks -lt 33 ]; then
    echo "faile"
if  [ $marks -lt 50 ]; then
    echo "third class"
if  [ $marks -lt 60 ]; then
    echo "second class"
if  [ $marks -lt 75 ]; then
    echo "first class"
else 
    echo "distaction"
fi
echo  "End"