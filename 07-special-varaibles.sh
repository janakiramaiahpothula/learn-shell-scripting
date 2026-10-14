#!/bin/bash

## Special varaibles

echo "all args passed to the script: $@"
echo "number of args passed to the script: $#"
echo "first vraible passed : $1"
echo "script name: $0"
echo "Realpath: $(realpath $0)"
echo "who is running current script: $USER" 
echo  "Directory of the current script: $PWD"
echo "Home directory of the current user: $HOME"
echo "Pid of the curent script: $$"
sleep 10
echo "Pid of the command runing in the background now: $!"
echo $!
echo "Line number: $LINENO"
echo "Previous command exit status: $?"
echo "Total time executed for this script: $SECONDS" 