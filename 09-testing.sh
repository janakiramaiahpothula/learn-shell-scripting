#!/bin/bash
name="Alice"
greeting='Hello, $name'      # single quotes: literal, no expansion
greeting2="Hello, $name"     # double quotes: variables expand

echo "$greeting"             # Hello, $name
echo "$greeting2"            # Hello, Alice

# String length
echo "Length: ${#name}"      # 5

# Substring (start at 1, take 3 chars)
echo "${name:1:3}"           # lic

# Replace
text="I like cats"
echo "${text/cats/dogs}"     # I like dogs

# Upper / lower case (Bash 4+)
echo "${name^^}"             # ALICE
echo "${name,,}"             # alice