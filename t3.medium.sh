#!/bin/bash

# Variables
AMI_NAME="Centos-8-DevOps-Practice"  
INSTANCE_TYPE="t3.medium"            
SECURITY_GROUP="ssg-062184d660bab16ba" 
REGION="us-east-1"                  
VOLUME_SIZE=30


AMI_ID=$(aws ec2 describe-images \
  --filters "Name=name,Values=$AMI_NAME" \
  --query "Images[0].ImageId" \
  --output text \
  --region $REGION)


if [ "$AMI_ID" == "None" ]; then
  echo "Error: AMI '$AMI_NAME' not found in region $REGION."
  exit 1
fi



