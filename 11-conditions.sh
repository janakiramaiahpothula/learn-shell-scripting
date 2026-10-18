#!/bin/bash

echo "Please enter the marks"
read marks

# lt -> less than

if [ $marks -lt 33 ]; then
    echo "Fail"
elif [ $marks -lt 50 ]; then
    echo "Third class"
elif [ $marks -lt 60 ]; then
    echo "Second class"
elif [ $marks -lt 75 ]; then
    echo "First class"
else
    echo "Distinction"
fi

echo "End"