#!/bin/bash

user_id=$(id -u)

if [ $user_id -ne 0 ]; then
  echo "please run this script with sudo access...."
  exit 1
fi 
  echo "Proceding"
  dnf install nginx -y
if [ $? -ne 0 ]; then
  echo "Nginx instalation failed"
  exit 1
else 
  echo "Nginx instalation success"
fi
  dnf install mysql -y
if [ $? -ne 0 ]; then
  echo "Mysql instalation failed"
  exit 1
else 
   echo "Mysql instalation sucess"
fi   
   echo "Still proceded....."

