#!/bin/bash

AMI_ID="ami-0b4f379183e5706b9"  
INSTANCE_TYPE="t2.micro"         
KEY_NAME="key_pair"         
SECURITY_GROUP="sg-062184d660bab16ba"  
SUBNET_ID="subnet-0c2799f4a5811c07f"      
REGION="us-east-1"              

echo "Launching EC2 instance of type t2.micro..."

aws ec2 run-instances \
  --image-id $AMI_ID \
  --instance-type $INSTANCE_TYPE \
  --key-name $KEY_NAME \
  --security-group-ids $SECURITY_GROUP \
  --subnet-id $SUBNET_ID \
  --region $REGION \
  --count 1 \
  --output json

echo "EC2 instance launched successfully."
