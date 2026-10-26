#!/bin/bash

user_id=$(id -u)
logs_floder="var/log/shell-practice"
logs_file="${logs_floder}/${0}.log"

if [ $user_id -ne 0 ]; then
    echo "Please run this script with sudo access.."
    exit 1
fi
 mkdir -p $logs_floder

 echo "Script excustion started at $(date +"%F %T")" &>> $logs_file
validate(){
    if [ $1 -ne 0 ]; then
        echo "${2}..FAILED"  | tee -a $logs_file
        exit 1
    else
        echo "${2}..SUCCESS" | tee -a $logs_file
    fi
}

echo "proceeding...."
dnf install nginx -y &>> $logs_file
validate $? "Nginx Installation" 

dnf install mysql -y &>> $logs_file
validate $? "Mysql Installation"

echo "Script excustion completed at $(date +"%F %T")" &>> $logs_file