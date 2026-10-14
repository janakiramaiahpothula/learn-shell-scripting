#!/bin/bash

## Special varaibles

echo "all args passed to the script: $@"
echo "number of args passed to the script: $#"
echo "first vraible passed : $1"
echo "script name: $0"
echo "Realpath: $(realpath $0)"
echo who is running current script: $USER" 