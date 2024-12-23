#!/bin/bash

NUMBER=$1
R="\e[31m"
N="\e[0m"

if [ $NUMBER -gt 100 ]
then 
    echo -e "$R Given number is greater than 100 $N"
else
    echo "Given number is lessthan 100"
fi