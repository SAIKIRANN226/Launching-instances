#!/bin/bash

ID=$(id -u)
DATE=$(date)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $ID -ne 0 ]
then 
    echo -e "$R ERROR:: Please run the script with root user $N"
    exit 1
else
    echo -e "$Y Script started executing at $DATE $N"
fi 

yum install git -y &>> temp.log

if [ $? -ne 0 ]
then 
    echo -e "$R Installing git is failed $N"
    exit 1
else
    echo -e "$G Installing git is SUCCESS $N"
fi

yum install mysql -y &>> temp.log

if [ $? -ne 0 ]
then 
    echo -e "$R Installing mysql is failed $N"
    exit 1
else
    echo -e "$G Installing mysql is SUCCESS $N"
fi