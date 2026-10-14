#!/bin/bash

START_TIME=$(date +%s)
echo "Script started execution at: $START_TIME"

sleep 10

END_TIME=$(date +%s)
echo "script completeed execution at: $END_TIME "

TOTAL_TIME=$(($END_TIME-START_TIME))
echo "Total time taken $TOTAL_TIME "