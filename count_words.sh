#!/bin/bash

file="notes.txt"

if[ -f "$file" ]; then
  count=$(wc -w < "$file")
  echo "Total nuber of words in file: $count"
else
  echo "File not found: $file"
fi
