#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

DATE=$(date)

if [ $ID -ne 0 ]
then 
    echo -e "$R ERORR:: Please run the script with root user $N"
    exit 1
else
    echo -e "$Y Script started executing at $DATE $N"
fi 

yum install git -y

if [ $? -ne 0 ]
then 
    echo -e "$R Installing git FAILED $N"
    exit 1
else
    echo -e "$G Installing git is SUCCESS
fi 