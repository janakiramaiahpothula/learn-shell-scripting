#!/bin/bash

printf "id\tname\trole\tstatus\tcompany\n"
printf "1\tAlice\tDeveloper\tACTIVE\tjoindevops\n"
printf "2\tBob\tTester\tINACTIVE\tjoindevops\n"
printf "3\tCharlie\tDevOps\tACTIVE\tjoindevops\n"
printf "4\tDave\tManager\tINACTIVE\tjoindevops\n"
printf "5\tEve\tArchitect\tACTIVE\tjoindevops\n"
printf "6\tFrank\tDeveloper\tACTIVE\tjoindevops\n"
printf "7\tGrace\tTester\tINACTIVE\tjoindevops\n"
printf "8\tHeidi\tDeveloper\tACTIVE\tjoindevops\n"
printf "9\tIvan\tDevOps\tINACTIVE\tjoindevops\n"
printf "10\tJudy\tManager\tACTIVE\tjoindevops\n" |
column -t -s $'\t'
