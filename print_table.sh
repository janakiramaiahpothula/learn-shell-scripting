#!/bin/bash

{
    printf "id\tname\ttrole\tstatus\tcompny\n"
    printf "1\tSai\tDevlope\tActive\tHCL\n"
    printf "2\tShiva\tTester\tActive\tCapgimini\n"
    printf "3\tRam\tDevOpsEngineer\tActive\tNTTData\n"
    printf "4\tVarma\tSalesEngineer\tActive\tInfosys\n"
    printf "5\tBhuvan\tFrontenedDV\tActive\tICICI\n"
    printf "6\tKumar\tBackendDV\tActive\tHDFC\n"
    
} | column -t -s $'\t'
