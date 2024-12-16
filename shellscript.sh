#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE() {
    if [ $1 -ne 0 ]
    then 
        echo -e "$2....$R FAILED $N"
        exit 1
    else
        echo -e "$2....$G SUCCESS $N"
    fi 
}

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
    echo -e "$G Installing git is SUCCESS $N"
fi

yum install postfix -y

VALIDATE $? "Installing postfix"

echo "This is a test log" > log.txt

yum install mysql -y 

VALIDATE $? "Installing mysql"

echo "This is a test log" > log.txt

