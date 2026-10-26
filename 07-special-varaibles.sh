#!/bin/bash

## Special varaibles

echo "all args passed to the script: $@"
echo "Number of args passed to the script: $#"
echo "First vraible passed: $1"
echo "Script name: $0"
echo "Realpath: $(realpath $0)"
echo "Who is running current script: $USER"