#!/bin/bash

file="notes.txt"

if [ -f  "$file" ]; then
   count=$(wc -w < "$file")
   echo "Total nuber of Words: $count"
else 
    echo "File not found: $file"
fi
