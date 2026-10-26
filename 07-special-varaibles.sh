#!/bin/bash

## Special varaibles

echo "all args passed to the script: $@"
echo "Number of args passed to the script: $#"
echo "First vraible passed: $1"
echo "Script name: $0"
echo "Realpath: $(realpath $0)"
echo "Who is running current script: $USER"
echo "Directory of the current script: $PWD"
echo "Home direcotry of the current user: $HOME"
echo "PID of the current script: $$"
sleep 05 &
echo "PID of the command running in background now: $!"
wait $!
echo "Line number : $LINENO"
echo "previous command exit status: $?"
echo "Total time excuted this for this script: $SECONDS"